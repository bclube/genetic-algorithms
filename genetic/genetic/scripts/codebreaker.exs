defmodule Codebreaker do
  use Problem
  use Bitwise

  def genotype do
    %Chromosome{
      genes: Stream.repeatedly(fn -> Enum.random(0..1) end)
        |> Enum.take(64),
      size: 64
    }
  end

  def fitness_function(chromosome) do
    target = "ILoveGeneticAlgorithms"
    encrypted = 'LIjs`B`k`qlfDibjwlqmhv'
    cipher = fn key ->
      Enum.map(encrypted, &(rem(Bitwise.bxor(&1, key), 32768)))
    end
    key =
      chromosome.genes
      |> Stream.map(&Integer.to_string/1)
      |> Enum.join()
      |> String.to_integer(2)

    guess = List.to_string(cipher.(key))
    String.jaro_distance(target, guess)
  end

  def terminate?([best | _], _generation) do
    best.fitness == 1
  end

  def crossover(p1, p2) do
    Toolbox.Crossover.single_point(p1, p2)
  end
end

solution = Genetic.run(Codebreaker)

{key, ""} =
  solution.genes
  |> Stream.map(&Integer.to_string/1)
  |> Enum.join()
  |> Integer.parse(2)

IO.write [
  "\nThe Key is ",
  Integer.to_string(key),
  "\n"
]
