defmodule Cfsjksas.Ancestors.Lineage do
  @moduledoc """
  operations on relationships

  mother(gen, relation) returns the mother of the relation
  father(gen, relation) returns the father of the relation
  gen_from_relation(relation) returns which generation that relation is in
  list_no_key_for_gen(gen, key) lists all the people in a generation who do not have that key
  list_no_link_key(gen) lists people in generation who don't have geni, myheritage, weeratle keys

  """

  require IEx

  def mother(gen, relation) do
    if not Map.has_key?(Cfsjksas.Ancestors.GetLineages.gen_relations(gen), relation) do
      IEx.pry()
    end
    # return mother of a person
    person = Cfsjksas.Ancestors.GetLineages.person(gen, relation)
    Map.get(person, :mother, nil)
  end

  def father(gen, relation) do
    # return mother of a person
    person = Cfsjksas.Ancestors.GetLineages.person(gen, relation)
    Map.get(person, :father, nil)
  end

  def gen_from_relation(0) do
    # initial generation
    0
  end
  def gen_from_relation(relation) do
    # generation is length of relation
    length(relation)
  end

  def list_no_key_for_gen(gen, key) do
    # get keys for gen
    Cfsjksas.Ancestors.GetLineages.person_list(gen)
    # print those that don't have key
    |> list_no_key_for_gen(gen, key)
  end
  def list_no_key_for_gen([], _gen, _key) do
    # done
    :ok
  end
  def list_no_key_for_gen([next_person | rest_people], gen, key) do
    # get full relation person
    person_r = Cfsjksas.Ancestors.GetLineages.person(gen, next_person)
    # get full people person
    person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)
    # see if they have key
    case Map.has_key?(person_p, key) do
      true ->
        # has it so continue
        nil
      false ->
        # print info on person without key
        text = to_string(person_p.id)
        <> ": "
        <> Cfsjksas.Ancestors.Person.get_name(person_p)
        IO.inspect(text)
    end
    # recurse thru rest
    list_no_key_for_gen(rest_people, gen, key)
  end

  def list_no_link_key(gen) do
    IO.inspect("MyHeritage:")
    list_no_key_for_gen(gen, :myheritage)
    IO.inspect("WeRelate:")
    list_no_key_for_gen(gen, :werelate)
    IO.inspect("Geni:")
    list_no_key_for_gen(gen, :geni)

  end

end
