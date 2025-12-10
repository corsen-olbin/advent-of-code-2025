defmodule AdventOfCodeEx.Core.Days.Day9 do


  def part_1(input) do
    input
    |> read_input()
    |> calc_square_areas([])
    |> Enum.max_by(fn {_x, _y, area} -> area end)
    |> elem(2)
  end

  def part_2(_input) do
    :unimplemented
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, ",") end)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end

  def calc_square_areas([], acc), do: acc
  def calc_square_areas([p | ps], acc) do
    new_acc =
      ps
      |> Enum.reduce(acc, fn p1, acc -> [{p, p1, calc_area(p, p1)} | acc] end)
    calc_square_areas(ps, new_acc)
  end

  def calc_area({x, y}, {x2, y2}) do
    (abs(x - x2) + 1) * (abs(y - y2) + 1)
  end
end
