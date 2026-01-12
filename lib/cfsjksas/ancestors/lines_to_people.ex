defmodule Cfsjksas.Ancestors.LinesToPeople do
  @moduledoc """
  create_people_map(line_map)
  """

  require IEx

  def create_map(line_map) do
    # initialize new map, key as id_a, value as empty list
    id_a_all = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    people_to_line = for id_a <- id_a_all, into: %{}, do: {id_a, []}

    # sort the keys so list of lines will be in correct order
    lines = line_map
    |> Map.keys()
    |> Enum.sort_by(fn line -> Cfsjksas.Tools.LineSort.sort_key(line) end)

    # for each line, add line to person in map
    p2l_update(people_to_line, lines)
  end

  defp p2l_update(people_to_line, []) do
    # done
    people_to_line
  end
  defp p2l_update(people_to_line, [line | rest_lines]) do
    # get id_a that goes with line
    # add line to that person's people_to_line
    id_a = Cfsjksas.Ancestors.AgentStores.line_to_id_a(line)
    new_value = people_to_line[id_a] ++ [line]

    people_to_line
    |> Map.put(id_a, new_value)
    |> p2l_update(rest_lines)
  end

end
