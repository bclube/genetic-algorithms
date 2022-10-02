defmodule Speller do
  use Problem
  alias Types.Chromosome

  @target "reallylong"
  @target_length String.length(@target)

  @impl Problem
  def genotype do
    %Chromosome{
      genes: Stream.repeatedly(fn -> Enum.random(?a..?z) end) |> Enum.take(@target_length),
      size: @target_length
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    chromosome.genes
    |> List.to_string()
    |> String.jaro_distance(@target)
  end

  @impl Problem
  def select(population, n) do
    Toolbox.Selection.tournament(population, n, 3)
  end

  @impl Problem
  def terminate?([best | _], _generation) do
    #generation > 99
    best.fitness > 0.8
  end
end

solution = Genetic.run(Speller)

IO.write("\n")
IO.inspect(solution)
