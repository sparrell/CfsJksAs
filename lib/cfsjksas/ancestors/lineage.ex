defmodule Cfsjksas.Ancestors.Lineage do
  @moduledoc """
  operations on relationships

  a_id_from_relation(relation) returns a_id of the relation
  mother(relation) returns the mother of the relation
  father(relation) returns the father of the relation
  gen_from_relation(relation) returns which generation that relation is in
  list_no_key_for_gen(gen, key) lists all the people in a generation who do not have that key
  list_no_link_key(gen) lists people in generation who don't have geni, myheritage, weeratle keys

  """

  require IEx

  @doc """
  from relation find ancestor
  """
  def a_id_from_relation(relation) do
    # get all keys
    a_ids = Cfsjksas.Chart.AgentStores.all_a_ids
    # look thru them till find one with relation
    a_id_from_relation(relation, a_ids)
  end
  def a_id_from_relation(_relation, []) do
    # oops. should have found
    IO.inspect("did not find relation")
  end
  def a_id_from_relation(relation, [a_id | rest_a_ids]) do
    ancestor = Cfsjksas.Chart.AgentStores.get_person_a(a_id)

    case relation in ancestor.relation_list do
      true ->
        #found ancestor with relation in relation list
        a_id
      false ->
        # go on to next
        a_id_from_relation(relation, rest_a_ids)
    end
  end

  @doc """
  get mother of relation
  """
  def mother(relation) do
    relation_a_id = a_id_from_relation(relation)
    person = Cfsjksas.Chart.AgentStores.get_person_a(relation_a_id)
    Map.get(person, :mother, nil)
  end

  @doc """
  get father of relation
  """
  def father(relation) do
    relation_a_id = a_id_from_relation(relation)
    person = Cfsjksas.Chart.AgentStores.get_person_a(relation_a_id)
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
    person_p = Cfsjksas.Chart.AgentStores.get_person_a(person_r.id)
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
