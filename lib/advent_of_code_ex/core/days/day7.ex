defmodule AdventOfCodeEx.Core.Days.Day7 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> read_input()
    |> propagate_beam()
  end

  def part_2(input) do
    input
    |> read_input()
    |> propagate_beam2()
  end

  def read_input(input) do
    map =
      input
      |> String.split("\r\n")
      |> Enum.map(&String.codepoints/1)
      |> Map2D.list2d_to_map2d

    beam_indexes = Map2D.find_all_indices(map, &(&1 === "S"))
    splitter_indexes =
      map
      |> Map2D.find_all_indices(&(&1 === "^"))
      |> Enum.sort_by(fn {x, _y} -> x end)

    {beam_indexes, splitter_indexes}
  end

  def propagate_beam({beams, splitters}), do: propagate_beam_rec(beams, [], splitters, 0)

  def propagate_beam_rec([], _, _, acc), do: acc
  def propagate_beam_rec([{row, col} | bs], hit_splitters, splitters, acc) do

    splitter = Enum.find(splitters, fn {x, y} -> col === y and x > row end)
    already_hit = Enum.any?(hit_splitters, fn spl -> spl === splitter end)

    if !splitter or already_hit do
     propagate_beam_rec(bs, hit_splitters, splitters, acc)
    else
      {x, y} = splitter
      propagate_beam_rec(
      Enum.uniq(bs ++ [{x, y-1}, {x, y+1}]) |> Enum.sort_by(fn {x, _y} -> x end),
      [splitter | hit_splitters],
      splitters,
      acc + 1)
    end
  end

  def propagate_beam2({[b | _], splitters}) do
    {sum, _ } = propagate_beam2_rec(b, splitters, %{})
    sum
  end

  def propagate_beam2_rec({row, col}, splitters, sum_map) do
    case Enum.find(splitters, fn {x, y} -> col === y and x > row end) do
      nil -> { 1, sum_map }
      {x, y} ->
        case Map.get(sum_map, {x, y}) do
          nil ->
            { suml, sum_map1 } = propagate_beam2_rec({x, y-1}, splitters, sum_map)
            { sumr, sum_map2 } = propagate_beam2_rec({x, y + 1}, splitters, sum_map1)
            {suml + sumr, Map.update(sum_map2, {x, y}, suml + sumr, fn x -> x end)}
          sum ->
            { sum, sum_map }
        end
    end
  end
end
