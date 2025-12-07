defmodule AdventOfCodeEx.Core.Days.Day6 do

  def part_1(input) do
    input
    |> read_input
    |> Enum.map(&calc_each/1)
    |> Enum.sum
  end

  def part_2(input) do
    input
    |> read_input_2 # also calcs the sum
  end

  def read_input(str) do
    str
    |> String.split("\r\n")
    |> Enum.map(fn line -> String.split(line, ~r/\s/, trim: true) end)
    |> Enum.zip_with(fn x -> x end)
  end

  def read_input_2(str) do
    [op_str | num_strs] =
      str
      |> String.split("\r\n")
      |> Enum.reverse

    op_chunks =
      Regex.scan(~r/.\s+/, op_str)
      |> List.flatten()

    nums =
      num_strs
      |> Enum.map(&String.codepoints/1)
      |> Enum.zip_with(fn list -> list |> Enum.reverse |> Enum.join |> String.trim end)

    # IO.inspect(nums)

    calc_sum_op_rec(op_chunks, nums, 0)
  end

  def calc_sum_op_rec([], _, acc), do: acc
  def calc_sum_op_rec([op | ops], num_strs, acc) do
    { nums, rest } = Enum.split(num_strs, String.length(op))

    o = String.trim(op)
    to_use = Enum.filter(nums, &(&1 !== ""))

    sol =
      case o do
        "+" -> Enum.reduce(to_use, 0, fn num, acc -> acc + String.to_integer(num) end)
        "*" -> Enum.reduce(to_use, 1, fn num, acc -> acc * String.to_integer(num) end)
      end

    calc_sum_op_rec(ops, rest, sol + acc)
  end

  def calc_each(list) do
    [operation | nums] = Enum.reverse(list)

    case operation do
      "+" -> Enum.reduce(nums, 0, fn num, acc -> acc + String.to_integer(num) end)
      "*" -> Enum.reduce(nums, 1, fn num, acc -> acc * String.to_integer(num) end)
    end
  end
end
