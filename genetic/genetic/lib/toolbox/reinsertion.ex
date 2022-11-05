defmodule Toolbox.Reinsertion do
  def pure(_parents, offspring, _leftovers), do: offspring

  def elitist(parents, offspring, leftovers, survival_rate) do
    old =
      parents
      |> Stream.concat(leftovers)
      |> Enum.sort_by(& &1.fitness, &>=/2)

    n = floor(length(old) * survival_rate)

    old
    |> Stream.take(n)
    |> Stream.concat(offspring)
  end

  def uniform(parents, offspring, leftover, survival_rate) do
    parents
    |> Stream.concat(leftover)
    |> Stream.filter(fn _ -> :rand.uniform() < survival_rate end)
    |> Stream.concat(offspring)
  end
end
