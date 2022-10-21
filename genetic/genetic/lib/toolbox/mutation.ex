defmodule Toolbox.Mutation do
  alias Types.Chromosome

  def flip(chromosome) do
    genes =
      Enum.map(
        chromosome.genes,
        &Bitwise.bxor(&1, 1)
      )

    %Chromosome{chromosome | genes: genes}
  end

  def flip(chromosome, p) do
    genes =
      Enum.map(
        chromosome.genes,
        fn g ->
          if :rand.uniform() < p do
            Bitwise.bxor(g, 1)
          else
            g
          end
        end
      )

    %Chromosome{chromosome | genes: genes}
  end

  def shuffle(chromosome) do
    %Chromosome{
      chromosome
      | genes: Enum.shuffle(chromosome.genes)
    }
  end

  def gaussian(chromosome) do
    mu = Enum.sum(chromosome.genes) / chromosome.size

    sigma =
      chromosome.genes
      |> Stream.map(&(mu - &1))
      |> Stream.map(&:math.pow(&1, 2))
      |> Enum.sum()
      |> Kernel./(chromosome.size)

    genes =
      Stream.repeatedly(fn -> :rand.normal(mu, sigma) end)
      |> Enum.take(chromosome.size)

    %Chromosome{chromosome | genes: genes}
  end
end
