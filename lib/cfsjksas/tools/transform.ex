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
    #prin_dad = relations[1]["P"] already in
    #prin_mom = relations[1]["M"]

    # bootstap the 'already' list with generation 0,1
		processed_a_id_list = [principal.id]

    # edit relations by adding termination for g0
    new_relations = relations
    |> put_in([0, 0, :termination], :not)

    # edit ancestors adding termination, parents
    new_ancestors = ancestors
    |> put_in([relations[0][0].id, :termination], :not)

    # shorthand for tuple
    r_a_i = {new_relations, new_ancestors, processed_a_id_list}

    dedup(r_a_i, Enum.to_list(1..15))
    # returns r_a_i
  end
  def dedup(r_a_i, []) do
    # no generations left
    #return {relations, ancestors, processed_a_id_list}
    r_a_i
  end
  def dedup(r_a_i, [gen | rest_gen]) do
    {relations, _ancestors, _processed_a_id_list} = r_a_i
    # sort relation_keys
    relation_keys = Map.keys(relations[gen])
    |> Enum.sort()

    r_a_i
    |> process_person(relation_keys)
    |> dedup(rest_gen)
    # returns r_a_i
  end

  def process_person(r_a_i, []) do
    # finished all people in this gen, move on
    r_a_i
  end
  def process_person(r_a_i, [this | rest_people]) do
    {relations, _ancestors, processed_a_id_list} = r_a_i
    gen = length(this) # generation is length of relations list
    person_id = relations[gen][this].id
    # see if person already on list of people processed
    prior = Enum.member?(processed_a_id_list, person_id)
    # if not on list, add to list, add empty termninations, and move on
    # if on list, add duplicate termination, and delete all ancestors

    process_dup(r_a_i, this, prior)
    # move on to next person
    |> process_person(rest_people)
  end

  def process_dup(r_a_i, this, false) do
    # prior = false ie first time seen
    # add id to processed_a_id_list
    # add category termination
    # return tuple of {new relations, ancestors, new processed_a_id_list}
    {relations, ancestors, processed_a_id_list} = r_a_i
    gen = length(this)
    person_id = relations[gen][this].id
    category = Cfsjksas.Ancestors.Person.categorize_person(person_id)
    #      termination:
    ##        - not
    ##        - both_brickwall
    ##        - mom_brickwall
    ##        - dad_brickwall
    ##        - branch
    ##        - duplicate
    ##        - immigrant_not_termination
    ##        - immigrant_termination

    relations_out = put_in(relations, [gen, this, :termination], category)

    ancestors_out = put_in(ancestors, [person_id, :termination], category)
    |> put_in([person_id, :primary_relation], this)

    processed_a_id_list_out = [person_id | processed_a_id_list]

    {relations_out, ancestors_out, processed_a_id_list_out}
  end
  def process_dup(r_a_i, this, true) do
    # prior = true ie this is a duplicate
    # don't add id to processed_a_id_list
    # add :duplicate termination
    # delete ancestors of the termination

    # relations
    #    - add termination:=:branch,
    #    - remove ancestors in relations
    # ancestors
    #    - add branch = this
    #    - for removed ancestors termination = duplicate
    # processed_a_id_list
    #    - unchanged

    {relations, ancestors, processed_a_id_list} = r_a_i
    gen = length(this)

    person_id = relations[gen][this].id
    relations2 = put_in(relations, [gen, this, :termination], :branch)
    ancestors2 = put_in(ancestors, [person_id, :branch], this)
    {relations2, ancestors2, processed_a_id_list}
    |>  rm_dups(gen + 1, this)
  end

  @doc """
  Recurse up thru generations, checking each person if they are ancestors of root_dup
  """
  def rm_dups(r_a_i, 15, _root_dup) do
    # if gen = 15, done
    r_a_i
  end
  def rm_dups(r_a_i, gen, root_dup) do
    # loop thru all people in gen and rm any that are ancestors of root_dup
    {relations, _ancestors, _processed_a_id_list} = r_a_i

    # get list of people for this generation using relation as key
    r_id_list = Map.keys(relations[gen])

    # recurse thru the people removing dups
    rm_dups(r_a_i, gen, root_dup, r_id_list)
  end
  def rm_dups(r_a_i, gen, root_dup, []) do
    # no people left in this generation, so go to next generation
    rm_dups(r_a_i, gen+1, root_dup)
  end
  def rm_dups(r_a_i, gen, root_dup, [this | rest]) do
    # check if "this" person is an ancestor of root_dup
    # if so, remove them from relations
    {relations, ancestors, processed_a_id_list} = r_a_i
    case root_dup == Enum.take(this, length(root_dup)) do
      false ->
        # not an ancestor, so return relations/ancestors unchanged
        r_a_i
      true ->
        # is an ancestor, so remove "this" node in relations
        relations2 = Map.update!(relations, gen, &Map.delete(&1, this))
        # any changes to ancestors??
        # no changes to id list
        {relations2, ancestors, processed_a_id_list}
    end
    # recurse on to rest of list using modified relations
    |> rm_dups(gen, root_dup, rest)
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
  made to pipe into format_ancestor_map and write_file
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
    #      termination:

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
