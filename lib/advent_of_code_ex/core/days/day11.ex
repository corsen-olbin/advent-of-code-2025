defmodule AdventOfCodeEx.Core.Days.Day11 do


  def part_1(input) do
    input
    |> read_input
    |> traverse_rec("you")
    |> elem(1)
  end

  def part_2(input) do
    input
    |> read_input()
    |> traverse2_rec(false, false, "svr")
    |> elem(1)
  end

  def read_input(input, default \\ nil) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn l -> String.split(l, ": ") end)
    |> Enum.reduce(%{}, fn [start, outputs], acc -> Map.put_new(acc, start, {String.split(outputs, " "), default}) end)
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

  def traverse2_rec(map, dac, fft, "out"), do: {map, (if dac and fft, do: 1, else: 0)}
  def traverse2_rec(map, dac, fft, node) do
    {outs, _num } = Map.get(map, node)
    new_dac = (node === "dac") or dac
    new_fft = (node === "fft") or fft

    # if num !== nil and dac and fft do
    #   {map, num}
    # else
      {final_map, total} =
        outs
        |> Enum.reduce({map, 0}, fn o, {m, n} ->
          {new_map, num} = traverse2_rec(m, new_dac, new_fft, o)
          {new_map, num + n}
        end)
      { Map.put(final_map, node, {outs, total}), total }
    #end
  end
end
