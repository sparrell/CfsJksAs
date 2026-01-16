defmodule Cfsjksas.Tools.MarkedHelpers do
  @moduledoc """
  helpers for making marked map
  """

  ### public api's ###

  @doc """
  iniitialize marked with sector info from lines
  """
  def init_marked() do
    # get all lines and sort in an order helping duplicate finding
    sorted_lines = Cfsjksas.Ancestors.AgentStores.line_to_id_a()
    |> Map.keys()
    |> Enum.sort_by(fn line -> Cfsjksas.Tools.LineSort.sort_key(line) end)

    # and use sorted list to initialis
    init_marked(%{}, sorted_lines)
  end

  @doc """
  init_sorted(sorted_lines) removes the 3 special initial cases already handled
  """
  def init_sorted(sorted_lines) do
    sorted_lines -- [[], [:m], [:p]]
  end

  @doc """
  convert line to sector
  """
  def sector_from_line(line) do
    sector_from_line(0, line)
  end

  @doc """
  determine if brickwall or not
  """
  def is_brickwall(person) do
    # brickwall if (1) no ship and (2) missing father or mother
    immigrant = Map.has_key?(person, :ship)
    case {immigrant, person.father, person.mother} do
      {true, _father, _mother} ->
        false
      {false, nil, _mother} ->
        true
      {false, _father, nil} ->
        true
      {false, father, mother} when father != nil and mother != nil ->
        false
    end
  end

  @doc """
  when hitting a branch, fillin the ancestors as duplicates
  process_ancestors(marked, sorted_lines, to_do)
  """
  def process_ancestors(marked, sorted_lines, []) do
    # no ancestors left to process
    {marked, sorted_lines}
  end
  def process_ancestors(marked, sorted_lines, [id_l | rest_to_to]) do
    # check if line in marked
    # if not, don't add this person and go to next
    # if yes:
    ##  add this person
    ##  add their father and mother
    ##  remove person's line from sorted_lines (so will skip when get to it since doing it now)
    exists = Map.has_key?(marked, id_l)
    process_ancestors(marked, sorted_lines, id_l, rest_to_to, exists)
  end

  @doc """
  get_quadrant(line) returns quadrant (:ne,:nw,:sw,:se)
  """
  def get_quadrant([:p, :p | _rest]) do :ne end
  def get_quadrant([:p, :m | _rest]) do :nw end
  def get_quadrant([:m, :p | _rest]) do :sw end
  def get_quadrant([:m, :m | _rest]) do :se end



  #### local functions ###
  # init_marked(marked_map, sorted_lines)
  defp init_marked(marked_map, []) do
    # no lines left so done
    marked_map
  end
  defp init_marked(marked_map, [[] | rest_lines]) do
    # special case for early gens
    key = {0, :ne, 0}
    value = %{
        brickwall: false,
        duplicate: :main,
        id_a: Cfsjksas.Ancestors.AgentStores.line_to_id_a([]),
        id_s: {0, :ne, 0},
        immigrant: :no,
        gen: 0,
        quadrant: :ne,
        relation: [],
        sector: 0,
  	}
    Map.put_new(marked_map, key, value)
    |> init_marked(rest_lines)
  end
  defp init_marked(marked_map, [[:p] | rest_lines]) do
    # special case for early gens
    key = {1, :ne, 0}
    value = %{
        brickwall: false,
        duplicate: :main,
        id_a: Cfsjksas.Ancestors.AgentStores.line_to_id_a([:p]),
        id_s: {1, :ne, 0},
        immigrant: :no,
        gen: 1,
        quadrant: :ne,
        relation: [:p],
        sector: 0,
  	}
    Map.put_new(marked_map, key, value)
    |> init_marked(rest_lines)
  end
  defp init_marked(marked_map, [[:m] | rest_lines]) do
    # special case for early gens
    key = {1, :se, 1}
    value = %{
        brickwall: false,
        duplicate: :main,
        id_a: Cfsjksas.Ancestors.AgentStores.line_to_id_a([:m]),
        id_s: {1, :se, 1},
        immigrant: :no,
        gen: 1,
        quadrant: :se,
        relation: [:m],
        sector: 1,
  	}
    Map.put_new(marked_map, key, value)
    |> init_marked(rest_lines)
  end
  defp init_marked(marked_map, [line | rest_lines]) do
    id_a = Cfsjksas.Ancestors.AgentStores.line_to_id_a(line)
    gen = length(line)
    quadrant = get_quadrant(line)
    sector = sector_from_line(line)
    id_s = {gen, quadrant, sector}
    key = id_s
    value = %{
      id_a: id_a,
      id_s: id_s,
      gen: gen,
      quadrant: quadrant,
      relation: line,
      sector: sector,
    }
    Map.put_new(marked_map, key, value)
    |> init_marked(rest_lines)
  end

  defp sector_from_line(accumulator, []) do
    # done
    accumulator
  end
  defp sector_from_line(accumulator, [this | rest_line]) do
    case this do
      :p ->
        # P = zero so recurse on
        sector_from_line(accumulator, rest_line)
      :m ->
        # M = binary 1 so add in
        new_acc = accumulator + (2 ** length(rest_line))
        # recurse on
        sector_from_line(new_acc, rest_line)
    end
  end

  # process_ancestors(marked, sorted_lines, id_l, rest_to_to, exists)

  defp process_ancestors(marked, sorted_lines, _id_l, rest_to_to, false) do
    # line isn't in marked so done up this line, move to next ancestor to do
    process_ancestors(marked, sorted_lines, rest_to_to)
  end
  defp process_ancestors(marked, sorted_lines, id_l, rest_to_to, true) do
    # line is in marked so:
    ## add person to marked,  duplicate = redundant
    ## remove id_l from sorted_lines (so won't process when get to it later since processing it now as duplicate)
    ## add person's parents to to_do

    ## add person to marked,  duplicate = redundant
    gen = length(id_l)
    quadrant = get_quadrant(id_l)
    sector = sector_from_line(id_l)
    id_s = {gen, quadrant, sector}
    # find the id_a for line
    id_a = Cfsjksas.Ancestors.AgentStores.line_to_id_a([])
    # note we know this is duplicate
    duplicate = :redundant
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
    immigrant = case person_a.ship do
      nil ->
        true
      _ ->
        false
    end
    brickwall = is_brickwall(person_a)

    new_marked = marked
    |> put_in([id_s, :duplicate], duplicate)
    |> put_in([id_s, :immigrant], immigrant)
    |> put_in([id_s, :brickwall], brickwall)

    ## remove id_l from sorted_lines (so won't process when get to it later since processing it now as duplicate)
    new_sorted_lines = sorted_lines -- [id_l]

    ## add person's parents to to_do
    father = id_l ++ [:p]
    mother = id_l ++ [:m]

    new_to_to = rest_to_to ++ [father] ++ [mother]

    ## recurse on
    process_ancestors(new_marked, new_sorted_lines, new_to_to)

  end



end
