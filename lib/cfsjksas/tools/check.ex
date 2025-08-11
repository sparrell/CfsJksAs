defmodule Cfsjksas.Tools.Check do
  @moduledoc """
  sanity checks
  """

  require IEx

  @doc """
  for a given ancestor, check their relations make sense
  """
  def ancestor_relations_consistent(a_id) do
    a_id
  end

  @doc """
  given a relation list, walk up the tree and give id of last person
  """
  def terminal_id(relation) do
    # start at prinicpal
    terminal_id(:p0005, relation)
  end
  defp terminal_id(a_id, []) do
    # done, return a_id
    a_id
  end
  defp terminal_id(a_id, 0) do
    # special inital case
    a_id
  end
  defp terminal_id(a_id, [ "P" | rest_relation]) do
    person = Cfsjksas.Ancestors.GetAncestors.person(a_id)
    if person == nil do
      #something wrong
      IO.inspect(a_id, label: "a_id")
      IO.inspect(person, label: "person")
      IO.inspect(rest_relation, label: "rest_relation")
      IEx.pry()
    end
    if person.father == nil do
      #something wrong
      IO.inspect(a_id, label: "a_id")
      IO.inspect(person, label: "person")
      IO.inspect(rest_relation, label: "rest_relation")
      IEx.pry()
    end
    # P so get father as new a_id
     terminal_id(person.father, rest_relation)
  end
  defp terminal_id(a_id, [ "M" | rest_relations]) do
    person = Cfsjksas.Ancestors.GetAncestors.person(a_id)
    # M so get mother as new a_id
     terminal_id(person.mother, rest_relations)
  end

  @doc """
  given an a_id, validate all the relations in the relation list
  """
  def ancestor_relations(a_id) do
    person = Cfsjksas.Ancestors.GetAncestors.person(a_id)
    relations = person.relation_list
    ancestor_relations(a_id, relations)
  end

  defp ancestor_relations(_a_id, []) do
      # all ok if got here
      :ok
    end
  defp ancestor_relations(a_id, [this_relation | rest_relations]) do
    term_id = terminal_id(this_relation)
    case term_id == a_id do
      true ->
        # ok so go to next
        ancestor_relations(a_id, rest_relations)
      false ->
        # something wrong, term_id != a_id so relation wrong
        IO.inspect(a_id, label: "a_id")
        IO.inspect(term_id, label: "term_id")
        IO.inspect(this_relation, label: "this_relation")
        IEx.pry()
    end
  end

  @doc """
  check all relations in all a_id's
  """
  def all_ancestor_relations() do
    all_ids = Cfsjksas.Ancestors.GetAncestors.all_ids()
    all_ancestor_relations(all_ids)

  end
  defp all_ancestor_relations([]) do
    # if got here, all ok
    :ok
  end
  defp all_ancestor_relations([a_id | rest_ids]) do
    case ancestor_relations(a_id) do
      :ok ->
        # working as should
        # go to next
        all_ancestor_relations(rest_ids)
      _ ->
        #what going on
        IEx.pry()
    end
  end

  @doc """
  for each person that has a father or mother,
  validate the father/mother has all the relations of the child
  with the added P/M
  """
  def all_parent_relations() do
    all_ids = Cfsjksas.Ancestors.GetAncestors.all_ids()
    all_parent_relations(all_ids)
  end
  defp all_parent_relations([]) do
    # if reached here, no problems
    IO.inspect("all parents checked out")
  end
  defp all_parent_relations([this_id | rest_ids]) do
    # for each person's non-nil mother and non-nil father
    ##  verify each of the person's relations are in parent
    ##  with additiona M or P as approriate
    child_person = Cfsjksas.Ancestors.GetAncestors.person(this_id)

    father_id = with %{father: father_id} <- child_person, false <- is_nil(father_id) do
      father_id
    else
      _ -> nil
    end

    case father_id do
      nil ->
        nil
      _ ->
        new_list = add_p(child_person.relation_list)
        check_relations(father_id, new_list)
    end

    mother_id = with %{mother: mother_id} <- child_person, false <- is_nil(mother_id) do
      mother_id
    else
      _ -> nil
    end

    case mother_id do
      nil ->
        nil
      _ ->
        new_list = add_m(child_person.relation_list)
        check_relations(mother_id, new_list)
    end

    # recurse to rest
    all_parent_relations(rest_ids)

  end

  defp add_p(relation_lists) do
    add_p([], relation_lists)
  end
  defp add_p(new_relation_lists, []) do
    # done updating, return new lists
    new_relation_lists
  end
  defp add_p(updated_relation_lists, [relations | rest_relations]) do
    # add p to current list and add that to new
    p_added = relations ++ ["P"]
    new_relation_lists = [p_added | updated_relation_lists]
    #recurse on
    add_p(new_relation_lists, rest_relations)
  end


  defp add_m(relation_lists) do
    add_m([], relation_lists)
  end
  defp add_m(new_relation_lists, []) do
    # done updating, return new lists
    new_relation_lists
  end
  defp add_m(updated_relation_lists, [relations | rest_relations]) do
    # add p to current list and add that to new
    m_added = relations ++ ["M"]
    new_relation_lists = [m_added | updated_relation_lists]
    #recurse on
    add_m(new_relation_lists, rest_relations)
  end

  defp check_relations(_a_id, []) do
    # done
    nil
  end
  defp check_relations(a_id, [relation | rest_relations]) do
    person = Cfsjksas.Ancestors.GetAncestors.person(a_id)
    if relation not in person.relation_list do
      # something wrong
      IO.inspect("*1 - relation not in person.relation_list")
      IO.inspect(a_id, label: "*1 - a_id")
      IO.inspect(relation, label: "*1 - relation")
      IO.inspect(person.relation_list, label: "*1 - person.relation_list")
    end
    # recurse to next relation
    check_relations(a_id, rest_relations)
  end



end
