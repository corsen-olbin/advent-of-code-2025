defmodule AdventOfCodeEx.Core.Days.Day4 do
alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    map = input
    |> convert_to_map

    Map2D.count_with_index(map, fn index, val -> less_than_four_trees(map, index, val) end)
  end

  def part_2(_input) do
    :unimplemented
  end

  def convert_to_map(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&String.codepoints/1)
    |> Map2D.list2d_to_map2d
  end

  def less_than_four_trees(map, {x, y}, val) when val == "@" do
    to_check = [{x-1, y-1}, {x-1, y}, {x-1, y+1},
                {x  , y-1},           {x  , y+1},
                {x+1,y-1},  {x+1, y}, {x+1, y+1}]

    count =
    to_check
    |> Enum.count(fn {x, y} -> Map2D.get(map, x, y) === "@" end)

    count < 4
  end
  def less_than_four_trees(_, _, _), do: false
end
