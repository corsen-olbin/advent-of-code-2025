defmodule AdventOfCodeEx.Core.Days.Day3 do


  def part_1(input) do
    input
    |> read_input()
    |> Enum.map(&convert_to_max/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> read_input()
    |> Enum.map(&convert_to_max_12/1)
    |> Enum.sum()
  end

  def read_input(input) do
    parse_func = fn x -> x |> String.codepoints() |> Enum.map(&String.to_integer/1) end
    input
    |> String.split("\r\n")
    |> Enum.map(&(parse_func.(&1)))
  end

  def convert_to_max(list) do
    m = Enum.max(list)
    mi = Enum.find_index(list, &(&1 == m))
    {max, max_index } =
      if mi + 1 == Enum.count(list) do
        { listm, _ } = Enum.split(list, mi)
        lm = Enum.max(listm)
        { lm, Enum.find_index(listm, &(&1 == lm)) }
      else
        {m, mi}
      end
    { _, rest } = Enum.split(list, max_index + 1)
    String.to_integer(Integer.to_string(max) <> Integer.to_string(Enum.max(rest)))
  end

  def convert_to_max_12(nums) do
    nums
    |> filter_top(12, [])
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  def filter_top([], _, acc), do: acc
  def filter_top(_, 0, acc), do: acc
  def filter_top(list, num, acc) when length(list) == num, do: acc ++ list
  def filter_top(list, num, acc) do
    search_list = Enum.slice(list, 0..-num//1)
    max = Enum.max(search_list)
    max_index = Enum.find_index(list, &(&1 == max))
    {_, new_list} = Enum.split(list, max_index + 1)
    filter_top(new_list, num - 1, acc ++ [max])
  end
end
