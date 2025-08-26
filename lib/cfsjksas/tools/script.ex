defmodule Cfsjksas.Tools.Script do
  @moduledoc """
  helpers to save typing when testing
  """
  require IEx

  def setup() do
    lineages = Cfsjksas.Tools.Relation.make_lineages()
    sectors = Cfsjksas.Tools.Relation.make_sector_lineages(lineages)
    marked = Cfsjksas.Tools.Relation.mark_lineages(sectors)

    marked_print(marked)

    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/reduced2.svg")


    Cfsjksas.Chart.Draw.main(marked)
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

    length(Map.keys(marked))
#    IO.inspect(marked[{0, :ne, 0}], label: "{0, :ne, 0}")
#    IO.inspect(marked[{1, :ne, 0}], label: "{1, :ne, 0}")
#    IO.inspect(marked[{1, :se, 1}], label: "{1, :se, 1}")
#    IO.inspect(marked[{6, :sw, 44}], label: "{6, :sw, 44}")
#    IO.inspect(marked[{5, :sw, 22}], label: "{5, :sw, 22}")
#    IO.inspect(marked[{4, :sw, 11}], label: "{4, :sw, 11}")
#    IO.inspect(marked[{12, :nw, 1896}], label: "{12, :nw, 1896}")
#    IO.inspect(marked[{13, :nw, 3779}], label: "{13, :nw, 3779}")
#    IO.inspect("----")

  end

  def marked_print(marked) do
    # sort the keys
    id_m_s = Map.keys(marked)
    |> Enum.sort()

    text = marked_print("%{\n", marked, id_m_s)
    <> "}\n"

    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/marked_ex.txt")

    File.write(filepath, text)
  end

  def marked_print(input, _marked, []) do
    # no more id's so done
    input
  end
  def marked_print(input, marked, [id_m | rest_id]) do
    # get person_m keys
    person = marked[id_m]

    keys = Map.keys(person)
    |> Enum.sort()

    input
    <> "\t" <> inspect(id_m) <> " => %{\n"
    <> person_m_print("", person, keys)
    <> "\t}\n"
    # pipe to recurse to next person
    |> marked_print(marked, rest_id)

  end

  def person_m_print(input_text, _person, []) do
    # no more keys so done
    input_text
  end
  def person_m_print(input_text, person, [key | rest_keys]) do
    input_text
    <> "      " <> inspect(key) <> ": " <> inspect(person[key]) <> ",\n"
    # and recurse to next key with above text as input
    |> person_m_print(person, rest_keys)
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
