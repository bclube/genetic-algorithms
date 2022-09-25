defmodule Genetic do
  def run(fitness_function, genotype, max_fitness, opts \\ []) do
    population = initialize(genotype, opts)
    evolve(population, fitness_function, genotype, max_fitness, opts)
  end

  def evolve(population, fitness_function, genotype, max_fitness, opts \\ []) do
    population = evaluate(population, fitness_function)
    best = hd(population)
    IO.write("\rCurrent Best: #{fitness_function.(best)}     ")
    if fitness_function.(best) >= max_fitness do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(fitness_function, genotype, max_fitness, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, opts \\ []) do
    Enum.sort_by(population, fitness_function, &>=/2)
  end

  def select(population, opts \\ []) do
    Stream.chunk_every(population, 2)
  end

  def crossover(population, pop_size, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    Stream.flat_map(
      population,
      fn [p1, p2] ->
        cx_point = :rand.uniform(population_size)
        {h1, t1} = Enum.split(p1, cx_point)
        {h2, t2} = Enum.split(p2, cx_point)
        [
          Enum.concat(h1, t2),
          Enum.concat(h2, t1)
        ]
      end
    )
  end

  def mutation(population, opts \\ []) do
    Stream.map(
      population,
      fn chromosome ->
        if :rand.uniform() < 0.05 do
          Enum.shuffle(chromosome)
        else
          chromosome
        end
      end
    )
  end
end
