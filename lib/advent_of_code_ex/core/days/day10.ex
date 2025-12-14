defmodule AdventOfCodeEx.Core.Days.Day10 do


  def part_1(input) do
    input
    |> read_input
    |> Enum.map(&find_least_actions/1)
    |> Enum.sum()
  end

  def part_2(_input) do
    :unimplemented
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&parse_string/1)
  end

  def parse_string(string) do
    [[_, lights]] = Regex.scan(~r/\[([.#]+)\]/, string)

    final =
      lights
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(0, fn {v, i}, acc -> if v === "#", do: Bitwise.bxor(2 ** i, acc), else: acc end)

    actions =
      Regex.scan(~r/\(([0-9,]+)\)/, string)
      |> Enum.map(fn [_, str] ->
        str
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> Enum.reduce(0, fn int, acc -> Bitwise.bor(2 ** int, acc) end)
      end)
    {final, actions}
  end

  def find_least_actions({final, actions}) do

    [_ | tail] = get_all(actions)
    shortest =
      tail
      |> Enum.sort_by(fn x -> length(x) end)
      |> Enum.find(fn x -> Enum.reduce(x, &Bitwise.bxor/2) === final end)

    length(shortest)
  end

  def get_all([]), do: [[]]
  def get_all([head | tail]) do
    sub_combinations = get_all(tail)
    sub_combinations ++ Enum.map(sub_combinations, fn list -> [head | list] end)
  end

end
