defmodule Cfsjksas.DevTools.AncestorRelations do
  @moduledoc """
  tools for finding ancestors and evaluating their relation list
  """

  require IEx

  @doc """
  check each ancestor of each id_a in input list
     validate has id_a_relations as subset
  """

  def check([]) do
    #done
    :ok
  end

  def check([id_a | rest]) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)

    rest
    |> check_father(id_a, person_a.relation_list, person_a.father)
    |> check_mother(id_a, person_a.relation_list, person_a.mother)
    |> check()
  end

  defp check_father(to_do, _child_id, _child_relations, nil) do
    # no father
    to_do
  end
  defp check_father(to_do,  child_id, child_relations, father_id) do
    # add father to each relation in child
    IO.inspect(child_id, label: "## child_id")
    child_list = Enum.map(child_relations, fn relation -> relation ++ ["P"] end)

    IO.inspect(father_id, label: "father_id")

    father = Cfsjksas.Ancestors.AgentStores.get_person_a(father_id)

    # see which child relations are not in father relations
    missing = child_list -- father.relation_list
    IO.inspect(missing, label: "missing")
    case missing do
      [] ->
        # all present, add father to to_do list
        [father_id | to_do]
      _ ->
        # missing items
        IO.inspect("child: #{child_id} father #{father_id} is missing:")
        IO.inspect(missing)
        IEx.pry()
    end
  end

    defp check_mother(to_do, _child_id, _child_relations, nil) do
    # no mother
    to_do
  end
  defp check_mother(to_do,  child_id, child_relations, mother_id) do
    IO.inspect(child_id, label: "## child_id")
    # add mother to each relation in child
    child_list = Enum.map(child_relations, fn relation -> relation ++ ["M"] end)

    IO.inspect(mother_id, label: "mother_id")
    mother = Cfsjksas.Ancestors.AgentStores.get_person_a(mother_id)

    # see which child relations are not in mother relations
    missing = child_list -- mother.relation_list
    IO.inspect(missing, label: "missing")
    case missing do
      [] ->
        # all present, add mother to to_do list
        [mother_id | to_do]
      _ ->
        # missing items
        IO.inspect("child: #{child_id} mother #{mother_id} is missing:")
        IO.inspect(missing)
        IEx.pry()
    end
  end


end
