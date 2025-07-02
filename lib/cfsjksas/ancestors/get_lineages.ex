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
    @ancestor_relations[gen][relation]
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
    tuple_list = Enum.map(this_gen_list, fn(x) -> {gen, x} end)
    # add to ancestors and recurse
    all_ancestor_keys(rest, ancestors ++ tuple_list)
  end

end
