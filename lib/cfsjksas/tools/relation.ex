defmodule Cfsjksas.Tools.Relation do
  @moduledoc """
  make_marked_sectors() - make marked sector map from ancestor data
  rm? make_lineages() - create base lineages map from ancestor(file) map
  sector_from_relation(relation) - give generation and sector for a given relation
  make_sector_lineages(base_lineage) - have {gen, sector} as primary key
  add_terminations_lineage(which_lineage) - add gen/sectors to each lineage along with terminations classified
          no_term / term
          ship
          no_ship
          brickwall-both
          brickwall-mom
          brickwall-dad
          duplicate (or is this it's own lineage "tag_lineage")
  make_reduced_lineage(tagged_lineage) - remove duplications beyond branch
          primary_duplicate
          branch_duplicate
          superfluous_duplicate

  then make new or updated svg and all other graphs
  remember to remove dedup etc once above ready


  """
  require IEx


  #################### new section below #####################
  # easier to hard code this than programatically

  @doc """
  make marked sector map from ancestor data
  """
  def make_marked_sectors() do

    # initialize marked for first several generations
    marked = Cfsjksas.Tools.MarkedHelpers.init_marked()

    # inialize the ancestors already marked main from initialization
    mains = [
      marked[{0, :ne, 0}].id_a,
      marked[{1, :ne, 0}].id_a,
      marked[{1, :se, 1}].id_a,
    ]

    # get all lines and sort in an order helping duplicate finding
    sorted_lines = Cfsjksas.Ancestors.AgentStores.line_to_id_a()
    |> Map.keys()
    |> Enum.sort_by(fn line -> Cfsjksas.Tools.LineSort.sort_key(line) end)
    # remove those initialized from sorted_lines
    |> Cfsjksas.Tools.MarkedHelpers.init_sorted()

    # walk thru lines, adding mains or dedupping
    make_marked_sectors(marked, sorted_lines, mains)
  end

  # make_marked_sectors(marked, sorted_lines, mains)
  defp make_marked_sectors(marked, [], _mains) do
    # no lines left so done
    marked
  end
  defp make_marked_sectors(marked, [line | rest_sorted_lines], mains) do
    # derive id_s components
    gen = length(line)
    quadrant = Cfsjksas.Tools.MarkedHelpers.get_quadrant(line)
    sector = Cfsjksas.Tools.MarkedHelpers.sector_from_line(line)
    id_s = {gen, quadrant, sector}

    # find the id_a for line
    id_a = Cfsjksas.Ancestors.AgentStores.line_to_id_a(line)
    # if id_a in mains, and line still in sorted_line (ie had not been removed as duplicate) then this is a branch
    duplicate = case id_a in mains do
      false ->
        :main
      true ->
        :branch
    end
    new_mains = case duplicate do
      :main ->
        mains ++ [id_a]
      :branch ->
        mains
    end
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
    immigrant = Map.has_key?(person_a, :ship)
    brickwall = Cfsjksas.Tools.MarkedHelpers.is_brickwall(person_a)

    # add person's new fields
    marked_with_add = marked
    |> put_in([id_s, :duplicate], duplicate)
    |> put_in([id_s, :immigrant], immigrant)
    |> put_in([id_s, :brickwall], brickwall)

    # if branch, mark ancestors and removed from rest_sorted_lines
    {marked_rm_branch, sorted_lines_rm_branch} = case duplicate do
      :main ->
        # no need to process ancestors
        {marked_with_add, rest_sorted_lines}
      :branch ->
        # temp variable to pass on father, mother
        father = line ++ [:p]
        mother = line ++ [:m]
        Cfsjksas.Tools.MarkedHelpers.process_ancestors(marked_with_add, rest_sorted_lines, [father, mother])
    end

    # recurse on
    make_marked_sectors(marked_rm_branch, sorted_lines_rm_branch, new_mains)
  end


  #################### new section above #####################

  def make_lineages() do
    IO.inspect("remember to remove dedup once complete")
    ids = Cfsjksas.Ancestors.GetAncestors.all_ids()
    # initialize lineages with 15 generations
    lineages = init_gen(%{}, Enum.to_list(0..15))
    # special case for primary principal
    |> put_in([0, []], %{})
    |> put_in([0, [], :id], Cfsjksas.Chart.GetCircleMod.config().primary)
    |> put_in([0, [], :quadrant], :ne)
    |> put_in([0, [], :sector], {0, 0})
    |> put_in([0, [], :relation], [])


    # go thru all ancestors adding in all the lineages
    make_lineages(lineages, ids)
  end
  # iterate thru all a_id's to add to lineages
  defp make_lineages(lineages, []) do
    # done
    lineages
  end
  defp make_lineages(lineages, [a_id | rest_ids]) do
    # for a_id, add each relation in its relation list to lineages map
    ## and iterate to next a_id
    add_relation(lineages, a_id,
                Cfsjksas.Ancestors.GetAncestors.person(a_id).relation_list)
    |> make_lineages(rest_ids)
  end

  # add in a relation to lineages map with value of a_id
  ## add_relation(lineages, a_id, a_id_relation_list)
  defp add_relation(lineages, _a_id, []) do
    # done
    lineages
  end
  defp add_relation(lineages, a_id, [this_relation | rest_relations]) do
    # calculate {gen, sector} for this_relation
    {gen, sector} = sector_from_relation(this_relation)
    # calculate quadrant
    quadrant = get_guadrant(this_relation)

    # update lineages.gen with {this_relation => %{ id: a_id}}
    ## and with {this_relation => %{sector: {gen, sector}}
    ## and with {this_relation => %{relation: this_relation}}
    ## and recurse
    ## note some redundancy but makes map value complete without having to tie to keys
    lineages
    |> put_in([gen, this_relation], %{})
    |> put_in([gen, this_relation, :id], a_id)
    |> put_in([gen, this_relation, :quadrant], quadrant)
    |> put_in([gen, this_relation, :sector], {gen, sector})
    |> put_in([gen, this_relation, :relation], this_relation)
    |> add_relation(a_id, rest_relations)
  end

  defp init_gen(lineages, []) do
    # done
    lineages
  end
  defp init_gen(lineages, [gen | rest]) do
    lineages # old lineages
    |> Map.put(gen, %{}) # add empty map at gen as key and feed next iteration
    |> init_gen(rest)
  end

  def sector_from_relation(relation) do
    gen = length(relation)
    sector = sector_from_relation(0, relation)
    {gen, sector}
  end
  defp sector_from_relation(accumulator, []) do
    # done
    accumulator
  end
  defp sector_from_relation(accumulator, [this | rest_relation]) do
    case this do
      :p ->
        # P = zero so recurse on
        sector_from_relation(accumulator, rest_relation)
      :m ->
        # M = binary 1 so add in
        new_acc = accumulator + (2 ** length(rest_relation))
        # recurse on
        sector_from_relation(new_acc, rest_relation)
    end
  end

    @doc """
    return quadrant based on relation
    primary, parents are special cases
    """
  def get_guadrant([]) do
    :ne
  end
  def get_guadrant([:p]) do
    :ne
  end
  def get_guadrant([:m]) do
    :se
  end
  def get_guadrant([:p, :p | _rest]) do
    :ne
  end
  def get_guadrant([:p, :m | _rest]) do
    :nw
  end
  def get_guadrant([:m, :p | _rest]) do
    :sw
  end
  def get_guadrant([:m, :m | _rest]) do
    :se
  end

  @doc """
  given lineage-based map, convert to {gen, sector} map with same values
  """
  def make_sector_lineages(base_lineage) do
    # walk thru generations
    make_sector_lineages(%{}, Map.keys(base_lineage), base_lineage)
  end
  defp make_sector_lineages(sectors, [], _base_lineage) do
    # finished generations
    sectors
  end
  defp make_sector_lineages(sectors, [this_gen | rest_gens], base_lineage) do
    # loop thru all people in this gen, adding them to sectors
    relation_keys = Map.keys(base_lineage[this_gen])
    make_sector_lineages(sectors, relation_keys, this_gen, base_lineage)
    |> make_sector_lineages(rest_gens, base_lineage)
  end
  defp make_sector_lineages(sectors, [], _this_gen, _base_lineage) do
    # done with this generation, return sectors
    sectors
  end
  defp make_sector_lineages(sectors, [this_relation | rest_relations], this_gen, base_lineage) do
    # add person to sectors using {gen, sector} as key
    person = base_lineage[this_gen][this_relation]
    {gen, sector} = person.sector
    quadrant = person.quadrant
    # use updated sectors to recurse
    sectors
    |> Map.put({gen, quadrant, sector}, person)
    |> make_sector_lineages(rest_relations, this_gen, base_lineage)
  end

  def sector_helper(sector_lineage, gen_print) do
    #print all items in a gen
    Enum.each(sector_lineage, fn
      {{gen, quadrant, sector}, person} ->
        case gen == gen_print do
          true ->
            IO.inspect("quadrant: #{inspect(quadrant)}, sector: #{inspect(sector)}, person: #{inspect(person)}")
          false ->
            nil
        end
    end)
  end

  @doc """
  mark each with lineage with:
    brickwall true/false
    immigrant no, no_ship, ship
    duplicate: main, branch, redundant

  first recurse thru generations
  second recurse thru quadrants
    ne,se,nw,sw order to 'skinny' the duplicates
  third recurse thru sectors

  keep track of which primaries already assigned for a person
  add in 'empty' brickwall entries for brickwall_mother, brickwall_father
  """
  def mark_lineages(sector_lineages) do
    # initialize new marked_lineage
    # Gen 0,1,2 are special cases since
    ## parent/child in same quadrant doesn't start
    ## until parent is Gen 3 and child is Gen 2
    marked_lineages = sector_lineages
    |> put_in([{0, :ne, 0}, :brickwall], false)
    |> put_in([{0, :ne, 0}, :immigrant], :no)
    |> put_in([{0, :ne, 0}, :duplicate], :main)
    |> put_in([{1, :ne, 0}, :brickwall], false)
    |> put_in([{1, :ne, 0}, :immigrant], :no)
    |> put_in([{1, :ne, 0}, :duplicate], :main)
    |> put_in([{1, :se, 1}, :brickwall], false)
    |> put_in([{1, :se, 1}, :immigrant], :no)
    |> put_in([{1, :se, 1}, :duplicate], :main)
    |> put_in([{2, :ne, 0}, :brickwall], false)
    |> put_in([{2, :ne, 0}, :immigrant], :no)
    |> put_in([{2, :ne, 0}, :duplicate], :main)
    |> put_in([{2, :nw, 1}, :brickwall], false)
    |> put_in([{2, :nw, 1}, :immigrant], :no)
    |> put_in([{2, :nw, 1}, :duplicate], :main)
    |> put_in([{2, :sw, 2}, :brickwall], false)
    |> put_in([{2, :sw, 2}, :immigrant], :no)
    |> put_in([{2, :sw, 2}, :duplicate], :main)
    |> put_in([{2, :se, 3}, :brickwall], false)
    |> put_in([{2, :se, 3}, :immigrant], :no)
    |> put_in([{2, :se, 3}, :duplicate], :main)

    # initialize primaries
    mains = [sector_lineages[{0, :ne, 0}].id,
            sector_lineages[{1, :ne, 0}].id,
            sector_lineages[{1, :se, 1}].id,
            sector_lineages[{2, :ne, 0}].id,
            sector_lineages[{2, :nw, 1}].id,
            sector_lineages[{2, :sw, 2}].id,
            sector_lineages[{2, :se, 3}].id,
            ]

    # generations to walk thru
    gens = Enum.to_list(3..15)

    # iterate thru generations
    mark_lineages_by_gen({marked_lineages, mains}, gens)
  end
  defp mark_lineages_by_gen({marked_lineages, _mains}, []) do
    # finished last gen so done, return marked_lineage
    marked_lineages
  end
  defp mark_lineages_by_gen({marked_lineages, mains}, [this_gen | rest_gens]) do
    # for this gen, recurse thru people in it

    # quad sort order to get reduced circle graph 'skinny'
    order = %{:ne => 0, :se => 1, :nw => 2, :sw => 3}
    # secondary sort will be on sector
    # note sort order makes a difference in determing main vs branch

    # make list of tuple-keys for this gen
    gen_tuples = marked_lineages
    |> Enum.filter(fn {{gen, _quadrant, _sector}, _value} ->
      gen == this_gen
      end)
    |> Enum.map(fn {tuple_key, _value} -> tuple_key end)
    |> Enum.sort_by(fn {_gen, quadrant, sector} ->
      {order[quadrant], sector}
      end)

    # recurse thru the people in sorted order
    mark_single_lineage({marked_lineages, mains}, gen_tuples)
    |> mark_lineages_by_gen(rest_gens)
  end
  defp mark_single_lineage({marked_lineage, mains}, []) do
    # finished gen_tuples so done, return {marked_lineage, mains}
    {marked_lineage, mains}
  end
  defp mark_single_lineage({marked_lineage, mains_in}, [{gen, quadrant, sector} | rest_gen_tuples]) do
    # add brickwall, immigrant, duplicate for this person
    # plus for brickwalls, add brickwall in next generation
    # plus for branches, mark everyone further out on tree as redundant
    # special case if this is already added brickwall

    # get person
    person_l = marked_lineage[{gen, quadrant, sector}]
    # update
    mark_single_lineage({marked_lineage, mains_in}, [{gen, quadrant, sector} | rest_gen_tuples], person_l)
  end
  defp mark_single_lineage({marked_lineage, mains_in}, [_this_gen_tuple | rest_gen_tuples], %{brickwall: true} = _person_l) do
    # special case if person is an already inserted brickwall
    {marked_lineage, mains_in}
    |> mark_single_lineage(rest_gen_tuples)
  end
  defp mark_single_lineage({marked_lineage, mains_in}, [{gen, quadrant, sector} | rest_gen_tuples], person_l) do
    person_a = Cfsjksas.Ancestors.GetAncestors.person(person_l.id)

    # person is not immigrant if person_a has no ship key
    # if there is a ship key, no_ship vs ship is determined by ship.name
    immigrant = ship_status(person_a)


    # for duplicate, see if this person already a duplicate or if already in mains
    duplicate = calc_duplicate(person_l, mains_in, marked_lineage)

    # if duplicate == main, add id to mains
    mains = case duplicate do
      :main ->
        mains_in ++ [person_a.id]
      _ ->
        mains_in
    end
    # if duplicate == branch, update upstream line as redundant (now or in recurse?)

    # brickwall of either mother or father, add new sectors in as brickwalls
    ## but not brickwall is noship or ship
    mother = person_a.mother
    father = person_a.father

    # update person. immigrant, duplicate, brickwall
    #
    {marked_lineage
    |> put_in([{gen, quadrant, sector}, :immigrant], immigrant)
    |> put_in([{gen, quadrant, sector}, :duplicate], duplicate)
    |> put_in([{gen, quadrant, sector}, :brickwall], false)
    |> add_brickwalls(person_l, person_a, duplicate)
    |> mark_redundants(duplicate, mother, father),
    mains}
    |> mark_single_lineage(rest_gen_tuples)
  end

  # mark_redundants(lineage, duplicate, mother, father)
  defp mark_redundants(lineage, _duplicate, _mother, _father) do
    lineage
  end

  defp add_brickwalls(lineages, person_l, person_a, duplicate) do
    # add in brickwall status, including of missing parents

    # calculate some precursors
    {gen, sector_num} = person_l.sector
    id_l = {gen, person_l.quadrant, sector_num}
    # brickwall of either mother or father, add new sectors in as brickwalls
    ## but not brickwall is noship or ship
    mother = person_a.mother
    father = person_a.father
    ship = Map.has_key?(person_a, :ship)
    brickwall = Map.has_key?(person_l, :brickwall) and person_l.brickwall

    cond do
      brickwall ->
        # already a brickwall, leave unchanged
        lineages
      unknown(person_a.surname) ->
        # if don't know surname, or already researched as bw, mark person as brickwall
        put_in(lineages, [id_l, :brickwall], true)
      ship ->
        # has ship so not brickwall regardless of parents
        lineages
      mother == nil and father == nil ->
        # no mother or father so add sector for both
        {father_tuple_id, father} = add_bw_mom_or_dad(:father, person_l, person_a, duplicate)
        {mother_tuple_id, mother} = add_bw_mom_or_dad(:mother, person_l, person_a, duplicate)
        lineages
        |> put_in([father_tuple_id], father)
        |> put_in([mother_tuple_id], mother)
      father == nil ->
        # has mother but no father, so add father brickwall sector
        {father_tuple_id, father} = add_bw_mom_or_dad(:father, person_l, person_a, duplicate)
        lineages
        |> put_in([father_tuple_id], father)
      mother == nil ->
        # has father but no mother, so add mother brickwall sector
        {mother_tuple_id, mother} = add_bw_mom_or_dad(:mother, person_l, person_a, duplicate)
        lineages
        |> put_in([mother_tuple_id], mother)
      true ->
        # not a brickwall
        put_in(lineages, [id_l, :brickwall], false)
    end

  end

  defp add_bw_mom_or_dad(parent, person_l, person_a, duplicate) do
    # gen = gen + 1
    # quadrant unchanged
    # sector for father = 2 * sector
    # sector for mother = (2 * sector) + 1
    # relation for partent is relation ++ [:p] or [:m] depending
    # make id from "father of" child or "mother of" child

    {child_gen, child_sector} = person_l.sector
    child_quad = person_l.quadrant

    # parent is one generation out from child
    parent_gen = child_gen + 1
    # relation = relation ++ ([:p] for [:m]
    parent_relation = case parent do
      :father ->
        person_l.relation ++ [:p]
      :mother ->
        person_l.relation ++ [:m]
    end
    # quad remains unchanged
    parent_quad = child_quad

    # make parent id from child with text on which parent
    parent_id = case parent do
      :father ->
        "father of " <> to_string(person_a.id)
      :mother ->
        "mother of " <> to_string(person_a.id)
    end

    parent_sector = case parent do
      :father ->
        2 * child_sector
      :mother ->
        (2 * child_sector) + 1
    end

    parent_tuple_id = {parent_gen, parent_quad, parent_sector}
    parent_duplicate = case duplicate do
      :main ->
        :main
      :branch ->
        :redundant
      :redundant ->
        :redundant
    end
    parent = %{
      id: parent_id,
      relation: parent_relation,
      quadrant: parent_quad,
      sector: {parent_gen, parent_sector},
      duplicate: parent_duplicate,
      brickwall: true,
      immigrant: :no
    }

    # return tuple of id and data
    {parent_tuple_id, parent}
  end

  @doc """
  check ship status of a person
  """
  def ship_status(person) do
    cond do
      not Map.has_key?(person, :ship) ->
        :no

      is_nil(person.ship) ->
        :no_ship

      person.ship == :parent ->
        :parent

      not is_map(person.ship) or not Map.has_key?(person.ship, :name) ->
        :no_ship

      is_nil(person.ship.name) ->
        :no_ship

      String.trim(to_string(person.ship.name)) == "" ->
        :no_ship

      true ->
        :ship
    end
  end

  @doc """
  calculate if this is a duplicate
  """
  def calc_duplicate(person_l, mains, marked) do
    # if person has duplicate key and value = redudant, then keep it that way
    # if child is redundant or branch, then duplicate = redundant
    # if not redundant and id already in mains, then person is branch
    # otherwise person is main

    # determine value of child's duplicate,
    child_duplicate = query_child_duplicate(person_l, marked)

    cond do
      Map.has_key?(person_l, :duplicate) and person_l.duplicate == :redundant ->
        :redundant
      child_duplicate == :redundant ->
        :redundant
      child_duplicate == :branch ->
        :redundant
      person_l.id in mains ->
        :branch
      true ->
        :main
    end
  end

  def gen_keys(lineage, gen) do
    # filter out keys just for one generation
    Map.keys(lineage)
    |> Enum.filter(fn
      {^gen, _, _} -> true
      _ -> false
    end)
  end

  # determine value of child's duplicate
  defp query_child_duplicate(person_l, marked) do
    # parent gen/sector_num
    {parent_gen, parent_sector_num} = person_l.sector
    # child's gen is one less than parents
    child_gen = parent_gen - 1
    # child quadrant is parent's quadrant
    child_quad = person_l.quadrant
    # child's sector_num is parent's sector num divided by 2 (ignore remainder)
    child_sector_num = div(parent_sector_num, 2)
    # child's id
    child_id = {child_gen, child_quad, child_sector_num}
    # look for data bugs
    if marked[child_id] == nil do
      IEx.pry()
    end
    # child's duplicate status (fudge for first gens)
    case child_gen > 1 do
      true ->
        marked[child_id].duplicate
      false ->
        :main
    end
  end

  # return true if surname blank or unknow or bw=researched brickwall, false otherwise
  def unknown(surname) do
    cond do
      is_nil(surname) ->
        true
      surname == "" ->
        true
      is_binary(surname) and (
        String.starts_with?(surname, "unknow") or
        String.starts_with?(surname, "Unknow")
      ) ->
        true
      is_binary(surname) and String.ends_with?(surname, "-*") ->
        true
      is_binary(surname) ->
        false
    end
  end

  @doc """
  make map with relation as key with id_m and id_a as values
  """
  def make_relation_ids(marked_lineages) do
    # start with empty map
    # for each entry in marked_lineages,
    ## make a new entry with relation as key
    ## and id_m, id_a, id_r as values


    Enum.reduce(marked_lineages, %{}, fn {top_key, inner_map}, acc ->
      rel_val = Map.get(inner_map, :relation)
      ida_val = Map.get(inner_map, :id)

      Map.put(acc, rel_val, %{id_a: ida_val, id_m: top_key, id_r: rel_val})
    end)


  end


####################
 @doc """
  make new relations file:
     - with primary duplicate marked (eventually)
     - with linked duplicate marked
     - with successive generation duplicates removed
     - with terminations marked:
        + duplicate
        + immigrant w ship (eventually)
        + immigrant wo ship(eventually)
        + brickwall (eventually)
        + normal

    dedup/0
      kicks off everything
      bootstraps id_list for g0,1
      bootstraps g0,1 terminations
      calls dedup/2
    dedup/2 (2-tuple of relations, id_list, list of generations)
      walks upward thru the generations
      gets list of people in that gen
      recurses thru each person calling process_person
    process_person/2 (3-tuple of relations,gen,id_list; list of people in this gen
        determine if person is a duplicate of someone already in id_list
        if duplicate, tag as duplicate and remove ancestors of duplicate
        if not duplicate, tag with category
        does above using process_dup/3
    process_dup/3 ({relations, gen, id_list}, this, prior)
      this = person being processed
      prior = whether person already in or not
        prior = false
          add person to id_list
          add empty term to person in relations
        prior = true
          add :duplicate term to person in relations
          remove all ancesctors of dup by calling rm_dups/
    rm_dups/3 (relations, gen, dup_root )
      note gen starts at one higher than the actual gen of the dup_root
      walk up the generations
      make list of all people in a gen
      check if person is ancestor of dup, remove if they are


  """

  def dedup() do
    # make new relations map starting from exiting map
    # start with a copy of existing map
    # leave generations 0,1,2 alone
    # process generations 3-14

    # start with existing relations file
    relations = Cfsjksas.Ancestors.GetLineages.all_relations()

    # bootstap the 'already' list
		id_list = [relations[0][0].id, relations[1][[:p]].id, relations[1][[:m]].id]

    # edit relations by adding termination for g0,1
    new_relations = relations
    |> put_in([0, 0, :termination], :not)
    |> put_in([1,[:p], :termination], :not)
    |> put_in([1,[:m], :termination], :not)

    dedup({new_relations, id_list}, Enum.to_list(2..14))
  end
  def dedup({relations, _id_list}, []) do
    # generations list empty so done
    relations
  end
  def dedup({relations, id_list}, [gen | rest_gen]) do
    # sort relation_keys
    relation_keys = Map.keys(relations[gen])
    |> Enum.sort()

    {relations, gen, id_list}
    |> process_person(relation_keys)
    |> dedup(rest_gen)
  end

  def process_person({relations, _gen, id_list}, []) do
    # finished all people in this gen, move on
    {relations, id_list}
  end
  def process_person({relations, gen, id_list}, [this | rest_people]) do
    person_id = relations[gen][this].id
    # see if person already on list of people processed
    prior = Enum.member?(id_list, person_id)
    # if not on list, add to list, add empty termninations, and move on
    # if on list, add duplicate termination, and delete all ancestors

    process_dup({relations, gen, id_list}, this, prior)
    # move on to next person
    |> process_person(rest_people)
  end

  def process_dup({relations, gen, id_list}, this, false) do
    # prior = false ie first time seen
    # add id to id_list
    # add category termination
    # return tuple of {new relations, gen, new id_list}
    person_id = relations[gen][this].id
    category = case person_id do
      nil ->
        raise "nil person_id"
      :bw ->
        :bw
      _ ->
        Cfsjksas.Ancestors.Person.categorize_person(person_id)
    end

######
#
#    if person_id == nil do
#      IEx.pry()
#    end
#   category = Cfsjksas.Ancestors.Person.categorize_person(person_id)

{ put_in(relations, [gen, this, :termination], category),
      gen,
      [relations[gen][this].id | id_list]
    }
  end
  def process_dup({relations, gen, id_list}, this, true) do
    # prior = true ie this is a duplicate
    # don't add id to id_list
    # add :duplicate termination
    # delete ancestors of the termination

    # first add termination:=:duplicate and then remove ancestors in relations
    # and return gen and id_list unchanged
    {put_in(relations, [gen, this, :termination], :duplicate)
      |> rm_dups(gen+1, this),
    gen,
    id_list
    }

  end

  @doc """
  Recurse up thru generations, checking each person if they are ancestors of root_dup
  """
  def rm_dups(relations, 15, _root_dup) do
    # if gen = 15, done
    relations
  end
  def rm_dups(relations, gen, root_dup) do
    # loop thru all people in gen and rm any that are ancestors of root_dup

    # get list of people for this generation using relation as key
    people_list = Map.keys(relations[gen])

    # recurse thru the people removing dups
    rm_dups(relations, gen, root_dup, people_list)
  end
  def rm_dups(relations, gen, root_dup, []) do
    # no people left in this generation, so go to next generation
    rm_dups(relations, gen+1, root_dup)
  end
  def rm_dups(relations, gen, root_dup, [this | rest]) do
    # check if "this" person is an ancestor of root_dup
    # if so, remove them from relations
    case root_dup == Enum.take(this, length(root_dup)) do
      false ->
        # not an ancestor, so return relations unchanged
        relations
      true ->
        # is an ancestor, so remove "this" node
        Map.update!(relations, gen, &Map.delete(&1, this))
    end
    # recurse on to rest of list using modified relations
    |> rm_dups(gen, root_dup, rest)
  end


end
