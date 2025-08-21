defmodule Cfsjksas.Tools.Script do
  @moduledoc """
  helpers to save typing when testing
  """
  require IEx

  def setup() do
    lineages = Cfsjksas.Tools.Relation.make_lineages()
    sectors = Cfsjksas.Tools.Relation.make_sector_lineages(lineages)
    marked = Cfsjksas.Tools.Relation.mark_lineages(sectors)
#    IO.inspect(marked[{0, :ne, 0}], label: "{0, :ne, 0}")
#    IO.inspect(marked[{1, :ne, 0}], label: "{1, :ne, 0}")
#    IO.inspect(marked[{1, :se, 1}], label: "{1, :se, 1}")
#    IO.inspect(marked[{6, :sw, 44}], label: "{6, :sw, 44}")
#    IO.inspect(marked[{5, :sw, 22}], label: "{5, :sw, 22}")
#    IO.inspect(marked[{4, :sw, 11}], label: "{4, :sw, 11}")
#    IO.inspect(marked[{12, :nw, 1896}], label: "{12, :nw, 1896}")
#    IO.inspect(marked[{13, :nw, 3779}], label: "{13, :nw, 3779}")
#    IO.inspect("----")
#    Cfsjksas.Tools.Script.list_marked_keys(marked, 6, :sw)
    # make list of tuple-keys for this gen
#    this_gen = 12
#    quad = :ne
#    gen_tuples = marked
#    |> Enum.filter(fn {{gen, _quadrant, _sector}, _value} ->
#      gen == this_gen
#      end)
#    |> Enum.map(fn {_tuple_key, value} -> value.brickwall end)


      # recurse thru looking for missing

#    IEx.pry()

  end

  @doc """
  Returns a sorted list of all sector values where the keys {gen, quad, sector}
  match the given gen_value and quad_value in the map.
  """
  def list_marked_keys(map, gen_value, quad_value) do
    map
    |> Map.keys()
    |> Enum.filter(fn {gen, quad, _sector} -> gen == gen_value and quad == quad_value end)
    |> Enum.map(fn {_gen, _quad, sector} -> sector end)
    |> Enum.sort()
  end

end
