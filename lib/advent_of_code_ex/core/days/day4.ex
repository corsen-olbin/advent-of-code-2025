defmodule AdventOfCodeEx.Core.Days.Day4 do
alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    map = input
    |> convert_to_map

    Map2D.count_with_index(map, fn index, val -> less_than_four_trees(map, index, val) end)
  end

  def part_2(input) do

      input
      |> convert_to_map()
      |> count_remove_while(0)
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


  def count_remove_while(map, acc) do
    indices = Map2D.find_all_indices_w_index(map, fn index, val -> less_than_four_trees(map, index, val) end)
    cond do
      length(indices) == 0 -> acc
      true ->
        new_map = indices |> Enum.reduce(map, fn {x, y}, acc -> Map2D.update(acc, x, y, ".", fn _ -> "." end) end)

        count_remove_while(new_map, acc + length(indices))
    end
  end
end
