defmodule Toolbox.Selection do
  def elite(population, n) do
    Stream.take(population, n)
  end

  def random(population, n) do
    Enum.take_random(population, n)
  end

  def tournament(population, n, tournament_size) do
    Stream.repeatedly(fn ->
      population
      |> Enum.take_random(tournament_size)
      |> Enum.max_by(& &1.fitness)
    end)
    |> Stream.uniq()
    |> Stream.take(n)
  end

  def roulette(population, n) do
    sum_fitness =
      population
      |> Stream.map(& &1.fitness)
      |> Enum.sum()

    Stream.repeatedly(fn ->
      u = :rand.uniform() * sum_fitness

      population
      |> Stream.scan(0, fn c, acc -> acc + c.fitness end)
      |> Enum.reduce_while(
        0,
        fn x, sum ->
          current_position = sum + x.fitness

          if current_position <= u do
            {:cont, current_position}
          else
            {:halt, x}
          end
        end
      )
    end)
    |> Stream.uniq()
    |> Stream.take(n)
  end
end
