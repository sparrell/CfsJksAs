defmodule Cfsjksas.Tools.Relation do
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
  require IEx

  def dedup() do
    # make new relations map starting from exiting map
    # start with a copy of existing map
    # leave generations 0,1,2 alone
    # process generations 3-14

    # start with existing relations file
    relations = Cfsjksas.Ancestors.GetLineages.all_relations()

    # bootstap the 'already' list
		id_list = [relations[0][0].id, relations[1][["P"]].id, relations[1][["M"]].id]

    # edit relations by adding empty termination list for g0,1
    new_relations = relations
    |> put_in([0, 0, :termination], :normal)
    |> put_in([1,["P"], :termination], :normal)
    |> put_in([1,["M"], :termination], :normal)

    dedup({new_relations, id_list}, Enum.to_list(2..14))
  end
  def dedup({relations, _id_list}, []) do
    # generations list empty so done
    relations
  end
  def dedup({relations, id_list}, [gen | rest_gen]) do
    # sort relation_keys with special sort
    relation_keys = Map.keys(relations[gen])
#    |> Enum.sort(&Cfsjksas.Tools.Relation.compare_relations/2)
    |> Enum.sort()

    {relations, gen, id_list}
    |> process_person(relation_keys)
    |> dedup(rest_gen)
  end

  def compare_relations(rel1, rel2) when rel1 == rel2 do
    IO.inspect("should not have got to compare_relations equal")
    true
  end
  def compare_relations(rel1, rel2) do
    [h1 | [h2 | tail1 ] ] = rel1
    [h3 | [h4 | tail2 ] ] = rel2

#    case {h1,h2,h3,h4} do
#      {"P","P","P","P"} ->
#        rel1 >= rel2
#      {"P","P", _ ,_ } ->
#        true
#      {_, _, "P", "P"} ->
#        false
#      {"M","M", _, _} ->
#        true
#      { _, _, "M","M"} ->
#        false
#      _ ->
#        rel1 >= rel2
#    end
    # compare first across quadrants, then within  quadrant
    case {h1, h2, tail1, h3, h4, tail2} do
      {"P", "P", tail1, "P", "P", tail2} ->
        # within NE quadrant
        ## go with 'smaller' (since M before P)
        ## to be closer to paternal line
        tail2 >= tail1
      {"P","P", _, _, _ ,_ } ->
        # NE (paternal) quadrant 'before' any other quadrant
        false
      { _, _, _, "P","P", _ } ->
        # NE (paternal) quadrant 'before' any other quadrant
        true
      {"M", "M", tail1, "M", "M", tail2} ->
        # SE (maternal) quadrant
        ## go with 'smaller' (since M before P)
        ## to be closer to paternal line
        tail2 >= tail1
      {"M", "M", _, _, _, _} ->
        # SE quadrant before any quad but NE
        false
      { _, _, _, "M", "M", _} ->
        # SE quadrant before any quad but NE
        true
      {"P", "M", tail1, "P", "M", tail2} ->
        # NE quadrant
        # go with 'larger' to be 'higher'
        tail1 >= tail2
      {"P", "M",  _, _, _, _} ->
        # NE quadrant before SE quad
        false
      {_, _,  _, "P", "M", _} ->
        # NE quadrant before SE quad
        true
      {"M", "P", tail1, "M", "P", tail2} ->
        #SW
        # go with 'smaller' to be 'lower'
        tail2 >= tail1
      _ ->
        # should have covered all comparisons?????
        IEx.pry()
    end
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
    category = Cfsjksas.Ancestors.Person.categorize_person(person_id)
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
