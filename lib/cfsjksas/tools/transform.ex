defmodule Cfsjksas.Tools.Transform do
  @moduledoc """
  start with ancestors file and make new ancestors file
  """
  require IEx

  def dup_lineage() do
    # start with existing ancestor and lineage maps
    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()
    relations = Cfsjksas.Ancestors.GetLineages.all_relations()

    # special cases for early generations
    principal = relations[0][0]
    prin_dad = relations[1]["P"]
    prin_mom = relations[1]["M"]

    # bootstap the 'already' list with generation 0,1
		id_list = [principal.id, prin_dad.id, prin_mom.id]

    # edit relations by adding termination for g0,1
    new_relations = relations
    |> put_in([0, 0, :termination], :not)
    |> put_in([1,["P"], :termination], :not)
    |> put_in([1,["M"], :termination], :not)

    # edit ancestors adding termination, parents
    new_ancestors = ancestors
    |> put_in([relations[0][0].id, :termination], :not)
    |> put_in([relations[1]["P"].id, :termination], :not)
    |> put_in([relations[1]["M"].id, :termination], :not)
    # adding their parents


    #dedup
  end

  def write_mom_dad() do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/try1_ex.txt")
    Cfsjksas.Tools.Transform.add_mom_dad()
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(filepath)
  end

  @doc """
  for each person_r in relations
  find a_id, mom, dad
  add mom, dad to person_a in ancestors
  output modified ancestors
  made to pipe into formatxxx and filexxx
  """
  def add_mom_dad() do

    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()
    relations = Cfsjksas.Ancestors.GetLineages.all_relations()
    generations = Enum.to_list(1..14) # do 0 special

    # principal is special case
    principal = relations[0][0]

    # add principal's:
    #      mom and dad,
    #      birth/death years,
    #      gen, sector
    #      termination
    ancestors
    |> put_in([principal.id, :father], principal.father)
    |> put_in([principal.id, :mother], principal.mother)
    |> put_in([principal.id, :birth_year], principal.birth_year)
    |> put_in([principal.id, :death_year], principal.death_year)
    |> put_in([principal.id, :generation], 0)
    |> put_in([principal.id, :sector], principal.sector)
    |> put_in([principal.id, :termination], :not)
    # do gen 1 - 14
    |> add_mom_dad(generations)
  end
  def add_mom_dad(ancestors, []) do
    # generations empty so done
    ancestors
  end
  def add_mom_dad(ancestors_in, [gen | rest_gens]) do
    # process each person in this generation
    people_r = Cfsjksas.Ancestors.GetLineages.gen_relations(gen)
    r_ids = Map.keys(people_r)
    add_mom_dad(ancestors_in, gen, rest_gens, r_ids)
  end
  def add_mom_dad(ancestors, _gen, rest_gens, []) do
    # no more people in this gen, recurse to next
    add_mom_dad(ancestors, rest_gens)
  end
  def add_mom_dad(ancestors_in, gen, rest_gens, [this_r | rest_r]) do
    # process this r
    person = Cfsjksas.Ancestors.GetLineages.person(gen, this_r)
    ancestors_in
    |> put_in([person.id, :father], person.father)
    |> put_in([person.id, :mother], person.mother)
    |> put_in([person.id, :birth_year], person.birth_year)
    |> put_in([person.id, :death_year], person.death_year)
    # recurse to next person
    |> add_mom_dad(gen, rest_gens, rest_r)
  end

end
