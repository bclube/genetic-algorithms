chromosome_length = 1000

genotype = fn -> for _ <- 1..chromosome_length, do: Enum.random(0..1) end
fitness_function = fn chromosome -> Enum.sum(chromosome) end
max_fitness = chromosome_length

solution = Genetic.run(fitness_function, genotype, max_fitness)

IO.write("\n")
IO.inspect(solution)
