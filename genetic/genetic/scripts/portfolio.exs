defmodule Portfolio do
  use Problem

  @size 10
  @target_fitness 180

  @impl Problem
  def genotype do
    %Chromosome{
      genes: for(_ <- 1..@size, do: gene()),
      size: @size
    }
  end

  defp gene do
    roi = :rand.uniform(10)
    risk = :rand.uniform(10)
    fitness = 2 * roi - risk
    {roi, risk, fitness}
  end

  @impl Problem
  def fitness_function(chromosome) do
    chromosome.genes
    |> Stream.map(fn {_roi, _risk, fitness} -> fitness end)
    |> Enum.sum()
  end

  @impl Problem
  def terminate?([best | _], _generation) do
    best.fitness > @target_fitness
  end

end

solution = Genetic.run(Portfolio)

IO.write("\n")
IO.inspect(solution)
