defmodule Cargo do
  @behaviour Problem
  alias Types.Chromosome

  @cargo_types [
    {1, 11},
    {2, 6},
    {3, 7},
    {5, 6},
    {6, 10},
    {6, 10},
    {6, 8},
    {7, 9},
    {8, 8},
    {9, 7},
  ]

  @impl Problem
  def genotype do
    %Chromosome{
      genes: (for _ <- 1..10, do: Enum.random(0..1)),
      size: 10
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    weight_limit = 40

    {total_profit, total_weight} =
      chromosome.genes
      |> Stream.zip(@cargo_types)
      |> Stream.flat_map(fn {g, cargo} -> if g == 1, do: [cargo], else: [] end)
      |> Enum.reduce({0, 0}, fn {profit, weight}, {tp, tw}  -> {tp + profit, tw + weight} end)

    if total_weight <= weight_limit do
      total_profit
    else
      0
    end
  end

  @impl Problem
  def terminate?(_population, generation) do
    generation > 999
  end
end

solution = Genetic.run(Cargo)

IO.write("\n")
IO.inspect(solution)

weight =
  solution.genes
  |> Stream.zip([10, 6, 8, 7, 10, 9, 7, 11, 6, 8])
  |> Stream.map(fn {g, w} -> g * w end)
  |> Enum.sum()

IO.write("\nWeight is: #{weight}\n")
