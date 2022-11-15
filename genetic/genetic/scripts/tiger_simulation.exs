defmodule TigerSimulation do
  use Problem

  @tropic_scores [0.0, 3.0, 2.0, 1.0, 0.5, 1.0, -1.0, 0.0]
  @tundra_scores [1.0, 3.0, -2.0, -1.0, 0.5, 2.0, 1.0, 0.0]

  @impl Problem
  def genotype do
    %Chromosome{
      genes: Stream.repeatedly(fn -> Enum.random(0..1) end) |> Enum.take(8),
      size: 8
    }
  end

  @impl Problem
  def statistics(population, generation) do
    if generation == 1 || rem(generation, 500) == 0 do
      {min, max, sum, count} =
        population
        |> Enum.reduce({nil, nil, 0, 0}, fn v, {min, max, sum, count} ->
          {
            if(min, do: min(min, v.fitness), else: v.fitness),
            if(max, do: max(max, v.fitness), else: v.fitness),
            sum + v.fitness,
            count + 1
          }
        end)

      stats = %{
        min_fitness: min,
        max_fitness: max,
        average_fitness: sum / count,
        average_tiger: average_tiger(population)
      }

      IO.write("\t")

      IO.inspect(stats)
    end

    :ok
  end

  defp average_tiger(population) do
    population_size = length(population)

    avg_fitness =
      population
      |> Stream.map(& &1.fitness)
      |> Enum.sum()
      |> Kernel./(population_size)

    avg_age =
      population
      |> Stream.map(& &1.age)
      |> Enum.sum()
      |> Kernel./(population_size)

    avg_genes =
      population
      |> Stream.map(& &1.genes)
      |> Stream.zip()
      |> Enum.map(
        &(&1
          |> Tuple.to_list()
          |> Enum.sum()
          |> Kernel./(population_size))
      )

    %Chromosome{
      age: avg_age,
      fitness: avg_fitness,
      genes: avg_genes
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    chromosome.genes
    |> Stream.zip(@tundra_scores)
    |> Stream.flat_map(fn
      {1, s} -> [s]
      _ -> []
    end)
    |> Enum.sum()
  end

  @impl Problem
  def terminate?(_population, generation) do
    generation >= 1_000
  end
end

solution =
  Genetic.run(
    TigerSimulation,
    population_size: 20,
    selection_rate: 0.9,
    mutation_rate: 0.1
  )

IO.write("\n")
IO.inspect(solution)
