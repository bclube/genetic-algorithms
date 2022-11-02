defmodule Problem do
  alias Types.Chromosome

  @callback genotype :: Chromosome.t()
  @callback fitness_function(Chromosome.t()) :: number()
  @callback select(Enum.t(), integer()) :: Enum.t()
  @callback crossover(Chromosome.t(), Chromosome.t()) :: Enum.t()
  @callback terminate?(Enum.t(), integer()) :: boolean()

  defmacro __using__(_opts) do
    quote do
      @behaviour Problem
      alias Types.Chromosome

      def select(population, n) do
        Toolbox.Selection.elite(population, n)
      end

      defoverridable select: 2

      def crossover(p1, p2) do
        Toolbox.Crossover.single_point(p1, p2)
      end

      defoverridable crossover: 2

      def mutate(chromosome) do
        Toolbox.Mutation.shuffle(chromosome)
      end

      defoverridable mutate: 1
    end
  end
end
