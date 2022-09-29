defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @chromosome_length 42
  @max_fitness @chromosome_length

  @impl Problem
  def genotype do
    %Chromosome{
      genes: for(_ <- 1..@chromosome_length, do: Enum.random(0..1)),
      size: @chromosome_length
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    Enum.sum(chromosome.genes)
  end

  @impl Problem
  def terminate?([best | _], _generation) do
    best.fitness == @max_fitness
  end

end

solution = Genetic.run(OneMax)

IO.write("\n")
IO.inspect(solution)
