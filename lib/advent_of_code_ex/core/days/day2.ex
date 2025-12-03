defmodule AdventOfCodeEx.Core.Days.Day2 do

  def part_1(input) do
    input
    |> read_input()
    |> find_invalid_sum(&is_invalid?/1)
  end

  def part_2(input) do
    input
    |> read_input()
    |> find_invalid_sum(&is_invalid_2?/1)
  end

  def read_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  def parse_range(str) do
    [start , last | _] = String.split(str, "-")
    s = String.trim(start)
    l = String.trim(last)
    String.to_integer(s)..String.to_integer(l)
  end

  def find_invalid_sum(ranges, is_invalid_func?) do
    ranges
    |> Enum.map(&Task.async(fn -> sum_invalids(&1, is_invalid_func?) end))
    |> Enum.map(&Task.await/1)
    |> Enum.sum
  end

  def sum_invalids(range, is_invalid_func?) do
    range
    |> Enum.to_list
    |> Enum.filter(&(is_invalid_func?.(&1)))
    |> Enum.sum
  end

  def is_invalid?(num) do
    str = Integer.to_string(num)
    length = String.length(str)
    {f, s} = String.split_at(str, div(length, 2))
    cond do
      rem(length, 2) == 1 -> false
      true -> f == s
    end
  end

  def is_invalid_2?(num) do

    str = Integer.to_string(num)
    length = String.length(str)
    chunk_size = div(length, 2)

    if chunk_size > 0 do
      1..chunk_size
      |> Enum.to_list()
      |> Enum.any?(&(check_string(&1, length, str)))
    else
      false
    end

  end

  def check_string(chunk_size, length, str) do
    cond do
      rem(length, chunk_size) != 0 -> false
      true -> (Enum.uniq(chunk_string(str, chunk_size)) |> Enum.count()) == 1
    end
  end

  def chunk_string(str, chunk_size) do
    str
    |> String.codepoints()
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(&Enum.join/1)
  end

end
