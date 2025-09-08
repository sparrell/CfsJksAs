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

  def get_name(person) do
    if person == nil do
      IEx.pry()
    end

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

  def get_name_dates(person) do
    name = get_name(person)
    birth = case person.birth_date do
      nil ->
        "?"
      _ ->
        person.birth_date
    end
    death = case person.death_date do
      nil ->
        "?"
      _ ->
        person.death_date
    end
    name <> " (" <> birth <> " - " <> death <> ")"
  end

  def ship(id) do
    person = Cfsjksas.Chart.AgentStores.get_person_a(id)
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
    Enum.map(wo_ships, fn x -> {x, x |> Cfsjksas.Ancestors.GetAncestors.person() |> get_name()} end)
  end

  def ship_people() do
    # make list of people on ships
    {has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, _normal
      } = categorize()
    Enum.map(has_ships, fn x -> {Cfsjksas.Ancestors.GetAncestors.person(x).ship.name,
                                x |> Cfsjksas.Ancestors.GetAncestors.person() |> get_name(),
                                x
                                } end)
  end

  def intermediate_people() do
    # make list of non-terminations
    {_has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, normal
      } = categorize()
    Enum.map(normal, fn x -> {x, x |> Cfsjksas.Ancestors.GetAncestors.person() |> get_name()} end)
  end

  def brick_walls() do
    # classify everyone as one of:
    ##   * not line termination
    ##   * line termination with ship
    ##   * line termination wo ship (return list)

    all_people = Cfsjksas.Ancestors.GetAncestors.all_ids()
    brick_walls(all_people, [])
  end
  defp brick_walls([], terminations) do
    # no one left so return brickwall list
    terminations
  end
  defp brick_walls([id | rest], terminations) do
    person = Cfsjksas.Chart.AgentStores.get_person_a(id)
    termination = case categorize_person(id) do
      :not -> []
      :ship -> []
      :no_ship -> []
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
    all_people = Cfsjksas.Chart.AgentStores.all_a_ids()
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
    # dtermine if person is:
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
    person = Cfsjksas.Chart.AgentStores.get_person_a(id)
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
    :not
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
    all_people = Cfsjksas.Ancestors.GetAncestors.all_ids()
    surnames(all_people, %{})
  end
  defp surnames([], surname_map) do
    # list empty so done
    # turn surname_map into sorted list of lists
    surname_map
    |> Map.to_list()
    |> Enum.sort()
  end
  defp surnames([id | rest], surname_map) do
    # get surname of this person
    person = Cfsjksas.Chart.AgentStores.get_person_a(id)
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
    ids = Cfsjksas.Ancestors.GetAncestors.all_ids()
    list_key_values([], ids, key)
  end
  defp list_key_values(values, [], _key) do
    # empty list so done
    values
  end
  defp list_key_values(values, [this | rest], key) do
    [Cfsjksas.Ancestors.GetAncestors.person(this)[key] | values]
    |> list_key_values(rest, key)
  end

  def relation_from_id(id) do
    # return person_r that has this id
    all_ancestor_ids = Cfsjksas.Ancestors.GetAncestors.all_ids()
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


end
