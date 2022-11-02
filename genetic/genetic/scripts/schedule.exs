defmodule Schedule do
  use Problem

  @max_hours 18.0

  @credit_hours [3.0, 3.0, 3.0, 4.5, 3.0, 3.0, 3.0, 3.0, 4.5, 1.5]
  @difficulties [8.0, 9.0, 4.0, 3.0, 5.0, 2.0, 4.0, 2.0, 6.0, 1.0]
  @usefulness [8.0, 9.0, 6.0, 2.0, 8.0, 9.0, 1.0, 2.0, 5.0, 1.0]
  @interest [8.0, 8.0, 5.0, 9.0, 7.0, 2.0, 8.0, 2.0, 7.0, 10.0]

  @impl Problem
  def genotype() do
    %Chromosome{
      genes: Stream.repeatedly(fn -> Enum.random(0..1) end) |> Enum.take(10),
      size: 10
    }
  end

  @impl Problem
  def fitness_function(chromosome) do
    {fitness, hours} =
      Stream.zip([chromosome.genes, @credit_hours, @difficulties, @usefulness, @interest])
      |> Stream.map(fn {class, credit_hours, difficulty, usefulness, interest} ->
        {
          class * (0.3 * usefulness + 0.3 * interest - 0.3 * difficulty),
          class * credit_hours
        }
      end)
      |> Enum.reduce({0, 0}, fn {fitness, hours}, {acc_fitness, acc_hours} ->
        {acc_fitness + fitness, acc_hours + hours}
      end)

    if hours > @max_hours, do: -999_999, else: fitness
  end

  @impl Problem
  def terminate?(_population, generation) do
    generation >= 1_000
  end
end

solution = Genetic.run(Schedule)

IO.write("\n")
IO.inspect(solution.genes)
