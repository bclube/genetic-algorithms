defmodule Genetic do
  alias Types.Chromosome

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)
    generation = 1

    evolve(population, problem, generation, opts)
  end

  def evolve(population, problem, generation, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1)
    best = hd(population)
    best_fitness = :erlang.float_to_binary(best.fitness, decimals: 4)
    IO.write("\rCurrent Best: population: #{length(population)} #{best_fitness}\t#{generation}")
    problem.statistics(population, generation)

    if problem.terminate?(population, generation) do
      best
    else
      {parents, leftover} = select(problem, population, opts)
      children = crossover(parents, problem)
      mutants = mutation(population, problem, opts)
      parents = Stream.flat_map(parents, & &1)

      children
      |> Stream.concat(mutants)
      |> reinsertion(parents, leftover, problem)
      |> backfill(problem, opts)
      |> evolve(problem, generation + 1, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def backfill(population, problem, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)

    population
    |> Stream.concat(Stream.repeatedly(&problem.genotype/0))
    |> Stream.take(population_size)
  end

  def evaluate(population, fitness_function) do
    population
    |> Stream.map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  def select(problem, population, opts \\ []) do
    select_rate = Keyword.get(opts, :selection_rate, 0.8)

    n = round(length(population) * select_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    parents = problem.select(population, n)
    parent_map = MapSet.new(parents)

    leftover =
      population
      |> Stream.filter(fn p -> not MapSet.member?(parent_map, p) end)

    parents = Stream.chunk_every(parents, 2)

    {parents, leftover}
  end

  def crossover(population, problem) do
    Stream.flat_map(
      population,
      fn [p1, p2] -> problem.crossover(p1, p2) end
    )
  end

  defp reinsertion(offspring, parents, leftover, problem) do
    problem.strategy(parents, offspring, leftover)
  end

  def mutation(population, problem, opts) do
    rate = Keyword.get(opts, :mutation_rate, 0.05)

    Stream.flat_map(
      population,
      fn chromosome ->
        if :rand.uniform() < rate do
          [problem.mutate(chromosome)]
        else
          []
        end
      end
    )
  end
end
