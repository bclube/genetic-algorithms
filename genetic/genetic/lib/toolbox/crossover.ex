defmodule Toolbox.Crossover do
  alias Types.Chromosome

  def single_point(p1, p2) do
    cx_point = :rand.uniform(p1.size)
    {h1, t1} = Enum.split(p1.genes, cx_point)
    {h2, t2} = Enum.split(p2.genes, cx_point)

    [
      %Chromosome{p1 | genes: Enum.concat(h1, t2)},
      %Chromosome{p2 | genes: Enum.concat(h2, t1)}
    ]
  end

  def order_one_crossover(p1, p2) do
    lim = p1.size

    [i1, i2] =
      [:rand.uniform(lim), :rand.uniform(lim)]
      |> Enum.sort()

    [
      %Chromosome{p1 | genes: order_one_splice(p2.genes, p1.genes, i1, i2)},
      %Chromosome{p2 | genes: order_one_splice(p1.genes, p2.genes, i1, i2)}
    ]
  end

  defp order_one_splice(p1, p2, i1, i2) do
    slice1 = Enum.slice(p1, i1..i2)
    slice1_set = MapSet.new(slice1)
    p2_contrib = Stream.reject(p2, &MapSet.member?(slice1_set, &1))
    {head2, tail2} = Enum.split(p2_contrib, i1)
    Enum.concat([head2, slice1, tail2])
  end

  def uniform(p1, p2, rate \\ 0.5) do
    {c1, c2} =
      p1.genes
      |> Stream.zip(p2.genes)
      |> Stream.map(fn {g1, g2} ->
        if :rand.uniform() < rate do
          {g1, g2}
        else
          {g2, g1}
        end
      end)
      |> Enum.unzip()

    [
      %Chromosome{p1 | genes: c1},
      %Chromosome{p2 | genes: c2}
    ]
  end

  def whole_arithmetic_crossover(p1, p2, alpha) do
    {c1, c2} =
      p1.genes
      |> Stream.zip(p2.genes)
      |> Stream.map(fn {x, y} ->
        one_minus_alpha = 1 - alpha

        {
          x * alpha + y * one_minus_alpha,
          y * alpha + x * one_minus_alpha
        }
      end)
      |> Enum.unzip()

    [
      %Chromosome{p1 | genes: c1},
      %Chromosome{p2 | genes: c2}
    ]
  end
end
