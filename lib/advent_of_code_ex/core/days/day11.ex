defmodule AdventOfCodeEx.Core.Days.Day11 do


  def part_1(input) do
    input
    |> read_input
    |> traverse_rec("you", "out")
    |> elem(1)
  end

  def part_2(input) do
    input
    |> read_input()
    |> traverse2()
  end

  def read_input(input, default \\ nil) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn l -> String.split(l, ": ") end)
    |> Enum.reduce(%{}, fn [start, outputs], acc -> Map.put_new(acc, start, {String.split(outputs, " "), default}) end)
  end

  def traverse2(map) do
    {_, count1 } = traverse_rec(map, "svr", "fft")
    {_, count2 } = traverse_rec(map, "fft", "dac")
    {_, count3 } = traverse_rec(map, "dac", "out")
    count1 * count2 * count3
  end

  def traverse_rec(map, final, final), do: {map, 1}
  def traverse_rec(map, "out", _), do: {map, 0}
  def traverse_rec(map, node, final) do
    {outs, num } = Map.get(map, node)

    if num !== nil do
      {map, num}
    else
      {final_map, total} =
        outs
        |> Enum.reduce({map, 0}, fn o, {m, n} ->
          {new_map, num} = traverse_rec(m, o, final)
          {new_map, num + n}
        end)
      { Map.put(final_map, node, {outs, total}), total }
    end
  end
end
