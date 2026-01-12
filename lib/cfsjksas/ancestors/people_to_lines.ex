defmodule Cfsjksas.Ancestors.PeopleToLines do
  @moduledoc """
  create_lines()
    start with the people map and derive a lines map.
    the people map uses :id as key
    the lines map uses a 'line' as key.
    line is a list of :m :p of the ancestry of principal person to reach a particular ancestor
    the length of the key tells you which generation that line terminates in
    note there is only one people id per person but can my multiple lines to an ancestor
    the data in the line map is the people key, whether the person is in an immigrant, brickwall, or native

  write_line_file(filename)
    put create_line output in a file
  """

  def create_lines() do
    # start with one person
    principal = :p0005
    # initialize lines map for that one person
    lines = %{
      [] => principal
    }
    # iterate thru generations
    gens = Enum.to_list(0..14)
    lines
    |> add_next_gen(gens)
  end

  # add_next_gen(lines, gens)
  defp add_next_gen(lines, []) do
    # no more generations so done
    lines
  end
  defp add_next_gen(lines, [gen | rest_gens]) do
    # find everyone in current gen, add their mom and pop as appropriate then go to next gen

    # this gen line_id's are all those with length = gen
    children = Enum.filter(Map.keys(lines), fn item -> length(item) == gen end)

    # iterate thru children, adding mom and pop
    lines
    |> add_child(children)
    # and then go to next gen
    |> add_next_gen(rest_gens)
  end

  # add_child(lines, children)
  defp add_child(lines, []) do
    # no more so done
    lines
  end
  defp add_child(lines, [child | rest_children]) do
    # add mom then pop for this child
    lines
    |> add_mom(child)
    |> add_pop(child)
    |> add_child(rest_children)
  end

  defp add_mom(lines, child_l) do
    # add mom (if she exists) to lines
    child_id = lines[child_l]
    child_a = Cfsjksas.Ancestors.AgentStores.get_person_a(child_id)
    # if no mom, return lines unchanged
    case child_a.mother do
      nil ->
        lines
      _ ->
        # need to add in mom at child_key_plus_m
        mom_l = child_l ++ [:m]
        lines
        |> Map.put_new(mom_l, child_a.mother)
    end
  end

  defp add_pop(lines, child_l) do
    # add pop (if he exists) to lines
    child_id = lines[child_l]
    child_a = Cfsjksas.Ancestors.AgentStores.get_person_a(child_id)
    # if no dad, return lines unchanged
    case child_a.father do
      nil ->
        lines
      _ ->
        # need to add in mom at child_key_plus_p
        dad_l = child_l ++ [:p]
        lines
        |> Map.put_new(dad_l, child_a.father)
    end
  end


end
