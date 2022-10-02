defmodule Problem do
  alias Types.Chromosome

  @callback genotype :: Chromosome.t
  @callback fitness_function(Chromosome.t) :: number()
  @callback select(Enum.t, integer()) :: Enum.t
  @callback terminate?(Enum.t, integer()) :: boolean()

  #@optional_callbacks select: 2
  defmacro __using__(_opts) do
    quote do
      @behaviour Problem

      def select(population, n) do
        Toolbox.Selection.elite(population, n)
      end

      defoverridable select: 2
    end
  end
end
