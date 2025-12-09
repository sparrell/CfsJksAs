defmodule Cfsjksas.Ancestors.Person do
  @moduledoc """
  functions for processing a person's data

  get_name(person) returns person's first and last names
  get_name_dates(person) returns person's name and birth/death dates
  ship(id) returns shipname or nil

  categorize() categorizes everybody
  categorize_person(id) categorizes an individual
  ship_people() lists everyone who has a ship
  no_ship_people() lists all immigrants wo a ship
  intermediate_people() lists everybody in the middle
  brick_walls() lists all terminations prior to immigrant

  surnames() lists all the surnames of everybody, and gives id's of all with each surname


  """

  require IEx

  def get_name(nil) do
    IO.inspect(Process.info(self(), :current_stacktrace))
    IO.inspect("nil person in get name")
    raise "get_name of nil person"
  end
  def get_name(person) do
    given = case person.given_name do
      nil ->
        "Unknown"
      _ ->
        person.given_name
    end
    surname = case person.surname do
      nil ->
        "Unknown"
      _ ->
        person.surname
    end
    given <> " " <> surname
  end
  def get_birth(nil) do
    IO.inspect(Process.info(self(), :current_stacktrace))
    raise "get_birth of nil person"
  end
  def get_birth(person) do
    case person.birth_year do
      nil ->
        "?"
      _ ->
        person.birth_year
    end
  end
  def get_death(nil) do
    IO.inspect(Process.info(self(), :current_stacktrace))
    raise "get_death of nil person"
  end
  def get_death(person) do
    case person.death_year do
      nil ->
        "?"
      _ ->
        person.death_year
    end
  end
  def get_dates(nil) do
    IO.inspect(Process.info(self(), :current_stacktrace))
    raise "get_dates of nil person"
  end
  def get_dates(person) do
    "(" <> get_birth(person) <> " - " <> get_death(person) <> ")"
  end

  def get_name_dates(nil) do
    IO.inspect(Process.info(self(), :current_stacktrace))
    IO.inspect("nil person in get_name_dates")
    raise "get_name_dates of nil person"
  end
  def get_name_dates(person) do
    get_name(person) <> " " <> get_dates(person)
  end

  def ship(id_a) do
    person = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
		if person == nil do
			IEx.pry()
		end
    if Map.has_key?(person, :ship) do
      Map.get(person, :ship, nil)
    else
      nil
    end
  end

  def no_ship_people() do
    # make list of immigrants wo ships
    {_has_ships, wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, _normal
    } = categorize()
    Enum.map(wo_ships, fn x -> {x, x |> Cfsjksas.Ancestors.AgentStores.get_person_a() |> get_name()} end)
  end

  def ship_people() do
    # make list of people on ships
    {has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, _normal
      } = categorize()
    Enum.map(has_ships, fn x -> {Cfsjksas.Ancestors.AgentStores.get_person_a(x).ship.name,
                                x |> Cfsjksas.Ancestors.AgentStores.get_person_a() |> get_name(),
                                x
                                } end)
  end

  def intermediate_people() do
    # make list of non-terminations
    {_has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, normal
      } = categorize()
    Enum.map(normal, fn x -> {x, x |> Cfsjksas.Ancestors.AgentStores.get_person_a() |> get_name()} end)
  end

  def brick_walls() do
    # classify everyone as one of:
    ##   * not line termination
    ##   * line termination with ship
    ##   * line termination wo ship (return list)

    all_people = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    brick_walls(all_people, [])
  end
  defp brick_walls([], terminations) do
    # no one left so return brickwall list
    terminations
  end
  defp brick_walls([id | rest], terminations) do
    person = Cfsjksas.Ancestors.AgentStores.get_person_a(id)
    termination = case categorize_person(id) do
      :not -> []      # intermediate person ie not a brickwall
      :ship -> []     # immigrant  ie not a brickwall
      :no_ship -> []  # immigrant  ie not a brickwall
      :parent -> []   # parent of immigrant  ie not a brickwall
      :brickwall_both ->
        # add data to list
        [{Enum.map(person.relation_list, &length/1),
			    id,
			    get_name(person),
			    Cfsjksas.Tools.Person.get_birth_place(person),
			    Cfsjksas.Tools.Person.get_death_place(person)
			  }]
      :brickwall_mother ->
        # add data to list
        [{Enum.map(person.relation_list, &length/1),
			    id,
			    get_name(person),
			    Cfsjksas.Tools.Person.get_birth_place(person),
			    Cfsjksas.Tools.Person.get_death_place(person)
			  }]
      :brickwall_father ->
        # add data to list
        [{Enum.map(person.relation_list, &length/1),
			    id,
			    get_name(person),
			    Cfsjksas.Tools.Person.get_birth_place(person),
			    Cfsjksas.Tools.Person.get_death_place(person)
			  }]
    end

    # recurse on with new terminations list
    brick_walls(rest, terminations ++ termination)
  end

  def categorize() do
    # categorize everyone as brickwall, known_ship, etc
    all_people = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    categorize(all_people, {[],[],[],[],[],[],[]})
  end
  defp categorize([], category_lists) do
    # to do list is done
    category_lists
  end
  defp categorize([id | rest], categories) do
    {has_ships, wo_ships, brickwalls_both, brickwalls_mother,
      brickwalls_father, parents, normal} = categories
    category = categorize_person(id)
    # return updated lists
    new_lists = case category do
      :ship ->
        {[id | has_ships],
        wo_ships,
        brickwalls_both,
        brickwalls_mother,
        brickwalls_father,
        parents,
        normal
        }
      :no_ship ->
        {has_ships,
        [id | wo_ships],
        brickwalls_both,
        brickwalls_mother,
        brickwalls_father,
        parents,
        normal
        }
      :brickwall_both ->
        {has_ships,
        wo_ships,
        [id | brickwalls_both],
        brickwalls_mother,
        brickwalls_father,
        parents,
        normal
        }
      :brickwall_mother ->
        {has_ships,
        wo_ships,
        brickwalls_both,
        [id | brickwalls_mother],
        brickwalls_father,
        parents,
        normal
        }
      :brickwall_father ->
        {has_ships,
        wo_ships,
        brickwalls_both,
        brickwalls_mother,
        [id | brickwalls_father],
        parents,
        normal
        }
      :parent ->
        {has_ships,
        wo_ships,
        brickwalls_both,
        brickwalls_mother,
        brickwalls_father,
        [id | parents],
        normal
        }

      :not ->
        {has_ships,
        wo_ships,
        brickwalls_both,
        brickwalls_mother,
        brickwalls_father,
        parents,
        [id | normal]
        }
    end
    # recurse
    categorize(rest, new_lists)
  end

  def categorize_person(id) do
    # determine if person is:
    ## brickwall
    ## immigrant with known ship
    ## immigrant without ship
    ## parent of immigrant (with or wo ship)
    #
    # depends on mother, father, and ship variables
    # parent is done manually
    if id == nil do
      IEx.pry()
    end
    person = Cfsjksas.Ancestors.AgentStores.get_person_a(id)
    if person == nil do
      IEx.pry()
    end
    mother = person.mother
    father = person.father
    has_ship? = Map.has_key?(person, :ship)
    categorize_person(id, has_ship?, mother, father, person)
  end

  defp categorize_person(_id, true, _mother, _father, person) do
    # has ship, further categorize
    ship_info(person.ship)
  end
  defp categorize_person(_id, false, mother, father, _person)
      when (mother != nil) and (father != nil) do
    # no ship, has mother and father, so not an immigrant nor brickwall
    :not
  end
  defp categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother == nil) and (father == nil) do
    # brickwall since no parents, no ship
    :brickwall_both
  end
  defp categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother == nil) and (father != nil) do
    # brickwall since no mother, no ship
    :brickwall_mother
  end
  defp categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother != nil) and (father == nil) do
    # brickwall since no parents, no ship
    :brickwall_father
  end
  defp categorize_person(id, has_ship?, mother, father, person) do
    #shouldn't get here
    IO.inspect{id, has_ship?, mother, father}
    IEx.pry()
  end

  defp ship_info(:parent) do
    :parent
  end
  defp ship_info(:parent_wo_ship) do
    :not
  end
  defp ship_info(:parent_w_ship) do
    :not
  end
  defp ship_info(nil) do
    :no_ship
  end
  defp ship_info(%{name: nil}) do
    :no_ship
  end
  defp ship_info(_ship) do
    :ship
  end

  def surnames() do
    # find all the surnames and list who has each
    all_people = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    surnames(all_people, %{})
  end
  defp surnames([], surname_map) do
    # list empty so done

    # determine how many people with unknown surname
    unknowns = length(surname_map["Unknown"])

    # turn surname_map into sorted list of lists
    surname_list = surname_map
    |> Map.to_list()
    |> Enum.sort()

    # return sorted list of surnames and number of people with unknown surname
    {surname_list, unknowns}
  end
  defp surnames([id | rest], surname_map) do
    # get surname of this person
    person = Cfsjksas.Ancestors.AgentStores.get_person_a(id)
    surname = get_surname(person.surname)

    # if surname in map, add this person otherwise add surname with this person
    new_map = case Map.has_key?(surname_map, surname) do
      false ->
        Map.put_new(surname_map, surname, [id])
      true ->
        current = surname_map[surname]
        new = [id | current]
        Map.put(surname_map, surname, new)
    end
    # recurse thru rest of people
    surnames(rest, new_map)
  end

  def get_surname(nil) do
    "Unknown"
  end
  def get_surname(name) do
    # return unmodified if short
    case String.length(name) < 8 do
      true ->
        name
      false ->
        <<head :: binary-size(7)>> <> _rest = name
        # truncate if "Unknownxxx"
        case head do
          "Unknown" ->
            "Unknown"
          _ ->
            name
        end
    end
  end

  def list_key_values(key) do
    # list value for key for everybody
    ids = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    list_key_values([], ids, key)
  end
  defp list_key_values(values, [], _key) do
    # empty list so done
    values
  end
  defp list_key_values(values, [this | rest], key) do
    [Cfsjksas.Ancestors.AgentStores.get_person_a(this)[key] | values]
    |> list_key_values(rest, key)
  end

  def relation_from_id(id) do
    # return person_r that has this id
    all_ancestor_ids = Cfsjksas.Ancestors.AgentStores.all_a_ids()
    # recurse thru all relation keys to find one that has this person_id
    relation_from_id(id, all_ancestor_ids)
  end
  def relation_from_id(id, []) do
    # didn't find????
    IEx.pry()
  end
  def relation_from_id(id, [this_ancestor_id | rest_ancestor_ids]) do
    # does "this" person have this ancestor id
IO.inspect(this_ancestor_id, label: "id1")
    person_p = Cfsjksas.Ancestors.GetLineages.person_from_relation(this_ancestor_id)
    case this_ancestor_id == id do
      true ->
        # match, return person_r
IO.inspect(person_p, label: "hit person_p, return person_r")
IEx.pry()
        #person_r
      false ->
        # mo match, recurse to next id
        relation_from_id(id, rest_ancestor_ids)
    end
  end

  @doc """
  determine 'completeness' of outer ring
  ie in percent, how much ship/no_ship/brickwall
  """
  def ring_percents() do
    # determine status of each ancestor
    category_lists = Cfsjksas.Ancestors.Person.categorize()
    has_ships = elem(category_lists, 0)
    wo_ships = elem(category_lists, 1)
    brickwalls_both = elem(category_lists, 2)
    brickwalls_mother = elem(category_lists, 3)
    brickwalls_father = elem(category_lists, 4)

    # create 'ring' representing 'outer edge'
    num_sectors = 2**14
    sectors = for i <- 0..(num_sectors-1), into: %{}, do: {i, nil}


    # mark ring for each termination
    ## noting 'inner' generations respond to multiple 'outer sectors'
    ## and worry about overlaps and gaps
    sectors
    |> mark_sectors(brickwalls_both, :brickwall_both)
    |> mark_sectors(brickwalls_father, :brickwall_father)
    |> mark_sectors(brickwalls_mother, :brickwall_mother)
    |> mark_sectors(wo_ships, :wo_ships)
    |> mark_sectors(has_ships, :ships)
    |> check_missing()
    |> summarize()
  end

  def mark_sectors(sectors, [], _termination) do
    #done
    sectors
  end
  def mark_sectors(sectors, [id_a | rest_id_a], termination) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
    relations = person_a.relation_list

    sectors
    |> mark_sectors(id_a, rest_id_a, termination, relations)
  end
  def mark_sectors(sectors, _id_a, rest_id_a, termination, []) do
    # done with relation list
    sectors
    |> mark_sectors(rest_id_a, termination)
  end
  def mark_sectors(sectors, id_a, rest_id_a, termination, [id_r | rest_relations]) do
    person_r = Cfsjksas.Ancestors.AgentStores.get_person_r(id_r)
    {orig_gen, _quadrant, orig_sector} = person_r.id_m
    {gen, sector, value} = case termination do
      :brickwall_both ->
        {orig_gen, orig_sector, :brickwall}
      :brickwall_father ->
        {orig_gen + 1, orig_sector * 2, :brickwall}
      :brickwall_mother ->
        {orig_gen + 1, (orig_sector * 2) + 1, :brickwall}
      :wo_ships ->
        {orig_gen, orig_sector, :no_ship}
      :ships ->
        {orig_gen, orig_sector, :ship}
    end
    gen_dif = 14 - gen
    # sectors in gen 14 corresponding to gen sector
    beg_range = sector * (2 ** gen_dif)
    end_range = ((sector + 1) * (2 ** gen_dif)) - 1

    updates = Enum.into(beg_range..end_range, %{}, fn key -> {key, value} end)
    Map.merge(sectors, updates)
    |> mark_sectors(id_a, rest_id_a, termination, rest_relations)
  end

  def check_missing(sectors) do
    # check all values of sectors are non-nil
    nil_keys = sectors
    |> Enum.filter(fn {_k, v} -> is_nil(v) end)
    |> Enum.map(fn {k, _v} -> k end)
    if nil_keys != [] do
      IEx.pry()
    end
    sectors
  end

  def summarize(sectors) do

    # Count occurrences of each value
    counts = Enum.reduce(sectors, %{:no_ship => 0, :ship => 0, :brickwall => 0}, fn {_key, value}, acc ->
      Map.update!(acc, value, &(&1 + 1))
    end)

    total = counts.ship + counts.no_ship + counts.brickwall

    # return ratios
    %{
      ship: counts.ship / total,
      no_ship: counts.no_ship / total,
      brickwall: counts.brickwall / total,
    }
  end


end
