defmodule Cfsjksas.Ancestors.Person do
  @moduledoc """
  functions for processing a person's data

  get_name returns person's first and last names

  """

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

  def ship(id) do
    person = Cfsjksas.Ancestors.GetAncestors.person(id)
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
    Enum.map(wo_ships, fn x -> {x, get_name(@ancestors[x])} end)

  end

  def ship_people() do
    # make list of people on ships
    {has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, _normal
      } = categorize()
    Enum.map(has_ships, fn x -> {@ancestors[x].ship.name, get_name(@ancestors[x]), x} end)
  end

  def intermediate_people() do
    # make list of non-terminations
    {_has_ships, _wo_ships, _brickwalls_both,
      _brickwalls_mother, _brickwalls_father,
      _parents, normal
      } = categorize()
    Enum.map(normal, fn x -> {get_name(@ancestors[x]), x} end)
  end

  def brick_walls() do
    # classify everyone as one of:
    ##   * not line termination
    ##   * line termination with ship
    ##   * line termination wo ship (return list)

    all_people = Map.keys(@ancestors)
    brick_walls(all_people, [])
  end
  def brick_walls([], terminations) do
    # no one left so return brickwall list
    terminations
  end
  def brick_walls([id | rest], terminations) do
    person = @ancestors[id]
    termination = case categorize_person(id) do
      :normal -> []
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
    all_people = Map.keys(@ancestors)
    categorize(all_people, {[],[],[],[],[],[],[]})
  end
  def categorize([], category_lists) do
    # to do list is done
    category_lists
  end
  def categorize([id | rest], categories) do
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
      :normal ->
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
    person = @ancestors[id]
    relations = person.relation_list
    [relation | _others] = relations
    gen = case relation do
      # initial person special case
      0 ->
        0
      _ ->
        length(relation)
    end
    mother = Cfsjksas.Ancestors.GetRelations.mother(gen, relation)
    father = Cfsjksas.Ancestors.GetRelations.father(gen, relation)
    has_ship? = Map.has_key?(person, :ship)
    categorize_person(id, has_ship?, mother, father, person)
  end

  def categorize_person(_id, true, _mother, _father, person) do
    # has ship, further categorize
    ship_info(person.ship)
  end
  def categorize_person(_id, false, mother, father, _person)
      when (mother != nil) and (father != nil) do
    # no ship, has mother and father, so not an immigrant nor brickwall
    :normal
  end
  def categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother == nil) and (father == nil) do
    # brickwall since no parents, no ship
    :brickwall_both
  end
  def categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother == nil) and (father != nil) do
    # brickwall since no mother, no ship
    :brickwall_mother
  end
  def categorize_person(_id, _has_ship?, mother, father, _person)
      when (mother != nil) and (father == nil) do
    # brickwall since no parents, no ship
    :brickwall_father
  end
  def categorize_person(id, has_ship?, mother, father, person) do
    #shouldn't get here
    IO.inspect{id, has_ship?, mother, father}
    IEx.pry()
  end

  def ship_info(:parent) do
    :normal
  end
  def ship_info(:parent_wo_ship) do
    :normal
  end
  def ship_info(:parent_w_ship) do
    :normal
  end
  def ship_info(nil) do
    :no_ship
  end
  def ship_info(%{name: nil}) do
    :no_ship
  end
  def ship_info(_ship) do
    :ship
  end

  def surnames() do
    # find all the surnames and list who has each
    all_people = Map.keys(@ancestors)
    surnames(all_people, %{})
  end
  def surnames([], surname_map) do
    # list empty so done
    # turn surname_map into sorted list of lists
    surname_map
    |> Map.to_list()
    |> Enum.sort()
  end
  def surnames([id | rest], surname_map) do
    # get surname of this person
    person = @ancestors[id]
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

end
