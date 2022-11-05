population = for _ <- 1..100, do: for(_ <- 1..1000, do: Enum.random(0..1))

evaluate = fn population ->
  Enum.sort_by(population, &Enum.sum/1, &>=/2)
end

selection = fn population ->
  population
  |> Stream.chunk_every(2)
end

crossover = fn population ->
  population
  |> Stream.flat_map(fn [p1, p2] ->
    cx_point = :rand.uniform(1000)
    {h1, t1} = Enum.split(p1, cx_point)
    {h2, t2} = Enum.split(p2, cx_point)

    [
      Enum.concat(h1, t2),
      Enum.concat(h2, t1)
    ]
  end)
end

mutation = fn population ->
  population
  |> Stream.map(fn chromosome ->
    if :rand.uniform() < 0.05 do
      Enum.shuffle(chromosome)
    else
      chromosome
    end
  end)
end

algorithm = fn population, algorithm ->
  population = evaluate.(population)
  best = List.first(population)
  worst = List.last(population)

  IO.write([
    "\rCurrent Best: ",
    Integer.to_string(Enum.sum(best)),
    " ",
    Integer.to_string(Enum.sum(worst)),
    "        "
  ])

  if Enum.sum(best) == 1000 do
    best
  else
    population
    |> selection.()
    |> crossover.()
    |> mutation.()
    |> algorithm.(algorithm)
  end
end

{time, solution} =
  :timer.tc(fn ->
    algorithm.(population, algorithm)
  end)

IO.write(["\n Time: ", Integer.to_string(time)])
IO.write("\n Answer is \n")
IO.inspect(solution)
