defmodule NQueens do
  use Problem

  @impl Problem
  def genotype do
    %Chromosome{
      genes: Enum.shuffle(0..7),
      size: 8
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    diag_clashes =
      for i <- 0..7, j <- 0..7 do
        if i != j do
          dx = abs(i - j)
          dy =
            abs(
              chromosome.genes
              |> Enum.at(i)
              |> Kernel.-(Enum.at(chromosome.genes, j))
            )
          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end

    length( Enum.uniq( chromosome.genes)) - Enum.sum( diag_clashes)
  end

  @impl Problem
  def terminate?([best | _], _generation) do
    best.fitness == 8
    #or generation > 3
  end

  @impl Problem
  def crossover(p1, p2) do
    Toolbox.Crossover.order_one_crossover(p1, p2)
  end

end

solution = Genetic.run(NQueens)

IO.write("\n")
for s <- solution.genes, i <- 0..7 do
  if s != i do
    IO.write(". ")
  else
    IO.write("* ")
  end
  if i == 7 do
    IO.puts("")
  end
end
IO.inspect(solution)
