defmodule AdventOfCodeEx.Core.Days.Day5 do

  def part_1(input) do
    input
    |> read_input()
    |> find_fresh_count()
  end

  def part_2(input) do
    input
    |> read_input()
    |> find_fresh_possible()
  end

  def read_input(input) do
    [rs, ns] = String.split(input, "\r\n\r\n", trim: true)

    ranges =
      rs
      |> String.split("\r\n")
      |> Enum.map(&to_range/1)

    nums =
      ns
      |> String.split("\r\n")
      |> Enum.map(&String.to_integer/1)

    { ranges, nums }
  end

  def to_range(str) do
    [b, e] = String.split(str, "-")

    String.to_integer(b)..String.to_integer(e)
  end

  def find_fresh_count({ranges, nums}) do
    nums
    |> Enum.count(fn num -> ranges |> Enum.any?(fn range -> num in range end) end)
  end

  def find_fresh_possible({ranges, _nums}) do
    ranges
    |> Enum.sort_by(fn b.._//_ -> b end)
    |> find_fresh_possible_rec([])
    |> Enum.reduce(0, fn range, acc -> acc + Range.size(range) end)
  end

  def find_fresh_possible_rec([], list), do: list
  def find_fresh_possible_rec([rb..re//_ = range | ranges], list) do
    i = Enum.find_index(list, fn l -> rb in l end)
    if i do
      lb..le//_ = Enum.at(list, i)
      find_fresh_possible_rec(ranges, List.replace_at(list, i, min(lb, rb)..max(le, re)))
    else
      find_fresh_possible_rec(ranges, [range | list])
    end
  end



end
