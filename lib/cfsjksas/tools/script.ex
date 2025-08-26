defmodule Cfsjksas.Tools.Script do
  @moduledoc """
  helpers to save typing when testing
  """
  require IEx

  def setup() do
    Cfsjksas.Tools.Print.print_marked_lineages()

    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/reduced2.svg")

    Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    |> Cfsjksas.Chart.Draw.main()
    |> Cfsjksas.Circle.Geprint.write_file(filepath)
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
