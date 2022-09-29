defmodule Genetic do
  alias Types.Chromosome

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)
    generation = 0

    evolve(population, problem, generation, opts)
  end

  def evolve(population, problem, generation, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)
    best = hd(population)
    IO.write("\rCurrent Best: #{best.fitness}     ")
    if problem.terminate?(population, generation) do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(problem, generation + 1, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Stream.map(
      fn chromosome ->
        fitness = fitness_function.(chromosome)
        age = chromosome.age + 1
        %Chromosome{chromosome | fitness: fitness, age: age}
      end
    )
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  def select(population, opts \\ []) do
    Stream.chunk_every(population, 2)
  end

  def crossover(population, opts \\ []) do
    Stream.flat_map(
      population,
      fn [p1, p2] ->
        cx_point = :rand.uniform(p1.size)
        {h1, t1} = Enum.split(p1.genes, cx_point)
        {h2, t2} = Enum.split(p2.genes, cx_point)
        [
          %Chromosome{p1 | genes: Enum.concat(h1, t2)},
          %Chromosome{p2 | genes: Enum.concat(h2, t1)},
        ]
      end
    )
  end

  def mutation(population, opts \\ []) do
    Stream.map(
      population,
      fn chromosome ->
        if :rand.uniform() < 0.05 do
          %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
        else
          chromosome
        end
      end
    )
  end
end
