defmodule AdventOfCodeEx.Core.Days.Day1 do


  def part_1(input) do
    input
    |> read_input
    |> calc_zeroes
  end

  def part_2(input) do
    input
    |> read_input
    |> IO.inspect
    |> calc_zeroes_2
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn x -> { (if String.slice(x, 0..0) == "R", do: :right, else: :left), String.slice(x, 1..4) |> String.to_integer } end)
  end

  def calc_zeroes(commands), do: calc_zeroes_rec(commands, 50, 0)

  def calc_zeroes_rec([], _, num_zero), do: num_zero
  def calc_zeroes_rec([{dir, num} | commands], pos, num_zero) do

    new_pos =
    case dir do
      :right -> rem(pos + num, 100)
      :left -> rem(pos - num + 100, 100)
    end

    new_num_zero = num_zero + (if new_pos == 0, do: 1, else: 0)

    calc_zeroes_rec(commands, new_pos, new_num_zero)
  end

  def calc_zeroes_2(commands), do: calc_zeroes_rec_2(commands, 50, 0)

  def calc_zeroes_rec_2([], _, num_zero), do: num_zero
  def calc_zeroes_rec_2([{dir, num} | commands], pos, num_zero) do

    { new_pos, add_num_zeros } = calc_rotations(dir, abs(num), pos)

    new_num_zero = num_zero + add_num_zeros
    IO.inspect({dir, num, new_pos, new_num_zero})
    calc_zeroes_rec_2(commands, new_pos, new_num_zero)
  end

  def calc_rotations(dir, num, pos), do: calc_rotations_rec(dir, num, pos, 0)

  def calc_rotations_rec(_, 0, pos, zeroes), do: {pos, zeroes}
  def calc_rotations_rec(dir, num, pos, zeroes) do
    new_pos =
    case dir do
      :right -> rem(pos + 1, 100)
      :left -> rem(pos - 1 + 100, 100)
    end
    calc_rotations_rec(dir, num - 1, new_pos, zeroes + (if new_pos == 0, do: 1, else: 0))
  end
end
