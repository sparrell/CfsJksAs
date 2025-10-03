defmodule Cfsjksas.Ancestors.GetLineages do
  @moduledoc """
  Turns text file of relations in elxir map

  all_relations() returns map with everyone by generation
  gen_relations(gen) returns one generation
  genlist() returns a list of the generations
  person_list(gen) returns a list relation-id for the people in a generation
  all_ancestor_keys() return everyone's relation-id across all generations
  person(gen, relation-id) returns the person's individual map

  """

  require IEx

  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "lineages_ex.txt"])
  @external_resource @data_path
  @ancestor_relations @data_path |> Code.eval_file() |> elem(0)


  def all_relations() do
    # return all the data
    @ancestor_relations
  end

  def gen_relations(gen) do
    # return all the people in a generation
    @ancestor_relations[gen]
  end

  def person(gen, relation) do
    # return a person
    person_r = @ancestor_relations[gen][relation]
    # note duplicates confuse this so check
    case person_r do
      nil ->
        # oops, need to find the duplicate
        id_map = Cfsjksas.Chart.AgentStores.get_person_r(relation)
        Cfsjksas.Chart.AgentStores.get_person_a(id_map.id_a)
      _ ->
        # non-nil so return it
        person_r
    end
  end

  def person_from_relation(relation) do
    # return a person
IO.inspect(relation, label: "relation1")
    gen = length(relation)
    person_r = @ancestor_relations[gen][relation]
    # note duplicates confuse this so check
    case person_r do
      nil ->
        # oops, need to find the duplicate
        person_from_dup_relation(relation)
      _ ->
        # non-nil so return it
        person_r
    end
  end
  def person_from_dup_relation(relation) do
IO.inspect(relation, label: "relation2")

    all_ids = Cfsjksas.Chart.AgentStores.all_a_ids
    person_from_dup_relation(relation, all_ids)
  end
  def person_from_dup_relation(relation, [this_id | rest_ids]) do
    # see if this person has relation in it's list
    person_p = Cfsjksas.Chart.AgentStores.get_person_a(this_id)
    case relation in person_p.relation_list do
      true ->
        # this is id of person but need to return person_r
IO.inspect(person_p, label: "this person hit")
        # which of this person's relations are the non-dup key
        IEx.pry()
      false ->
        # not this person, go to next
        person_from_dup_relation(relation, rest_ids)
    end
  end

  def genlist() do
    # return a list of the generations
    Map.keys(@ancestor_relations)
  end

  def person_list(gen) do
    # return a list of people in a generation
    Map.keys(@ancestor_relations[gen])
  end

  def all_ancestor_keys() do
    gens = Map.keys(@ancestor_relations)
    all_ancestor_keys(gens, [])
  end
  defp all_ancestor_keys([], ancestors) do
    # gen list empty so done
    ancestors
  end
  defp all_ancestor_keys([gen | rest], ancestors) do
    this_gen_list = Map.keys(@ancestor_relations[gen])
    #tuple_list = Enum.map(this_gen_list, fn(x) -> {gen, x} end)
    # add to ancestors and recurse
    #all_ancestor_keys(rest, ancestors ++ tuple_list)
    all_ancestor_keys(rest, ancestors ++ this_gen_list) #
  end

end
