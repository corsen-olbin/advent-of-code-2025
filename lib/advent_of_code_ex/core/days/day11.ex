defmodule AdventOfCodeEx.Core.Days.Day11 do


  def part_1(input) do
    input
    |> read_input
    |> traverse_rec("you")
    |> elem(1)
  end

  def part_2(_input) do
    :unimplemented
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn l -> String.split(l, ": ") end)
    |> Enum.reduce(%{}, fn [start, outputs], acc -> Map.put_new(acc, start, {String.split(outputs, " "), nil}) end)
  end

  def traverse_rec(map, "out"), do: {map, 1}
  def traverse_rec(map, node) do
    {outs, num } = Map.get(map, node)

    if num !== nil do
      {map, num}
    else
      {final_map, total} =
        outs
        |> Enum.reduce({map, 0}, fn o, {m, n} ->
          {new_map, num} = traverse_rec(m, o)
          {new_map, num + n}
        end)
      { Map.put(final_map, node, {outs, total}), total }
    end
  end

end
