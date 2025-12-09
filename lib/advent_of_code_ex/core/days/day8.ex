defmodule AdventOfCodeEx.Core.Days.Day8 do

  def part_1(input) do
    input
    |> read_input
    |> find_all_euc_distance
    #|> IO.inspect()
    |> find_num_shortest_pairs(1000) # 1000 for real one, 10 for example
    #|> IO.inspect(limit: :infinity)
    |> build_circuits([])
    #|> IO.inspect(limit: :infinity, width: 100)
    |> Enum.sort_by(fn l -> length(l) end, :desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn x, acc -> length(x) * acc end)
  end

  def part_2(_input) do
    :unimplemented
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn str -> String.split(str, ",") end)
    |> Enum.map(fn [x, y, z | []] -> {String.to_integer(x) , String.to_integer(y), String.to_integer(z)} end)
  end

  def find_all_euc_distance(points), do: find_all_euc_dist_rec(points, %{})

  def find_all_euc_dist_rec([], acc), do: acc
  def find_all_euc_dist_rec([p | ps], acc) do
    new_acc =
      ps
      |> Enum.reduce(acc, fn op, a -> Map.put(a, {p, op}, str_line_dist(p, op)) end)
    find_all_euc_dist_rec(ps, new_acc)
  end

  def str_line_dist({x, y, z}, {x2, y2, z2}) do
    (Integer.pow(x - x2, 2) + Integer.pow(y - y2, 2) + Integer.pow(z - z2, 2)) ** 0.5
  end

  def find_num_shortest_pairs(map, num) do
      map
      |> Map.to_list()
      |> Enum.sort_by(fn {_, dist} -> dist end)
      |> Enum.take(num)
  end
  def build_circuits([], acc), do: acc
  def build_circuits([{{p1, p2}, _} | list], acc) do
    p1i = Enum.find_index(acc, fn l -> p1 in l end)
    p2i = Enum.find_index(acc, fn l -> p2 in l end)

    cond do
      p1i === p2i and is_number(p1i) -> build_circuits(list, acc)
      p1i === nil and is_number(p2i) -> build_circuits(list, List.update_at(acc, p2i, fn l -> [p1 | l] end))
      p2i === nil and is_number(p1i) -> build_circuits(list, List.update_at(acc, p1i, fn l -> [p2 | l] end))
      p2i !== p1i and is_number(p2i) and is_number(p1i) ->
        {p2l, a} = List.pop_at(acc, p2i)
        new_p1i = Enum.find_index(a, fn l -> p1 in l end)
        new_acc = List.update_at(a, new_p1i, fn l -> l ++ p2l end)
        build_circuits(list, new_acc)
      p2i === nil and p1i === nil -> build_circuits(list, [[p1, p2] | acc])
    end
  end
end
