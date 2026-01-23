defmodule Cfsjksas.Ancestors.AgentStores do
  @moduledoc """
  routines for accessing data in the Agent storage
  - get_ancestors()
        get entire ancestor map
  - get_person_a(id_a)
        get one person from ancestor
  - all_a_ids()
        get list of all ancestor id's
  - get_marked_sector_map()
        get marked map
  - get_all_sector_ids()
        get keys for sector mape
  - get_marked_lineages() ????rm eventually
        get entire marked lineage map
  - get_person_m(id_m)
        get person from marked lineage map using {gen, quad, sector} id
  - all_m_ids()
        get list of marked lineage id's
  - m_ids_by_gen
        list all the m_id's in a generation
  - get_relation_map()
        get entire relation map (key is relation, value id_a, id_m)
  - get_person_r(id_r)
        get person from relation map
  - all_r_ids()
        list all of id_r
  - id_a_by_gen(gen)
        list of ancestor id's for a generation
  """

  require IEx

  @quad_order %{ne: 0, se: 1, nw: 2, sw: 3}


  @doc """
  Get Ancestor map
  """
  def get_ancestors() do
    Agent.get(:ancestors, fn map -> map end)
  end

  @doc """
  Get person map in ancestor format
  """
  def get_person_a(id_a) do
    Agent.get(:ancestors, fn map -> Map.get(map, id_a) end)
  end

  @doc """
  get all the id_a (ie ancestor id's ie the atom eg :p0005)
  """
  def all_a_ids() do
    Agent.get(:ancestors, fn map -> Map.keys(map) end)
    |> Enum.sort()
  end

  @doc """
  get the "sector" map with everyone "marked"
  sector key is {gen, quadrant, sector} eg {3, :ne, 2}
  marked means including the brickwall, duplicate, immigrant fields
  """
  def get_marked_sector_map() do
    Agent.get(:marked_sectors, fn map -> map end)
  end

  @doc """
  get all the sector id's eg a list of the items of the form {3, :ne, 2}
  """
  def get_all_sector_ids() do
    Agent.get(:marked_sectors, fn map -> map end)
    |> Map.keys()
    |> Enum.sort()
  end

  @doc """
  should get_marked_lineages go away?
  """
  def get_marked_lineages() do
    IO.inspect("get_marked_lineages - replace?")
    IEx.pry() # traceback why called
    # {:current_stacktrace, stack} = Process.info(self(), :current_stacktrace)
    # IO.inspect(stack, label: "STACKTRACE")
    Agent.get(:marked_lineages, fn map -> map end)

  end
  def get_person_m(id_m) do
#    Agent.get(:marked_lineages, fn map -> Map.get(map, id_m) end)
    Agent.get(:marked_lines, fn map -> Map.get(map, id_m) end)
  end

  def all_m_ids() do

#    Agent.get(:marked_lineages, fn map -> Map.keys(map) end)
    Agent.get(:marked_sectors, fn map -> Map.keys(map) end)
    |> Enum.sort_by(fn {gen, quad, sect} ->
      {gen, Map.fetch!(@quad_order, quad), sect}
    end)
  end

  @doc """
  list all the m_id's in a generation
  """
  def m_ids_by_gen(gen) do

    all_m_ids()
    |> Enum.filter(fn
      {^gen, _quadrant, _sector} -> true
      _ -> false
    end)
    |> Enum.sort_by(fn {gen, quad, sect} ->
      {gen, Map.fetch!(@quad_order, quad), sect}
    end)
  end

  def get_relation_map() do
    Agent.get(:relation_map, fn map -> map end)
  end

  def get_person_r(id_r) do
    x = Cfsjksas.Ancestors.AgentStores.line_to_id_a(id_r)
IEx.pry() # rm - this routing has been replaced by line_to_id_a
    Agent.get(:relation_map, fn map -> Map.get(map, id_r) end)
  end

  def all_r_ids() do
    Agent.get(:relation_map, fn map -> Map.keys(map) end)
    |> Enum.sort_by(fn relation ->
      {length(relation), relation}
    end)

  end

  def id_a_by_gen(gen) do
    m_ids_by_gen(gen)
    |> Enum.map(fn id_m ->
      get_person_m(id_m).id
    end)
  end

  def id_a_by_gen() do
    IO.inspect("why? does this work?")
    all_r_ids()
    |> Enum.map(fn id_r ->
      get_person_r(id_r).id_a
    end)
  end

  @doc """
  return the id_a for a line
  """
  def line_to_id_a(line) do
    Agent.get(:lines_to_id_a, fn map -> Map.get(map, line) end)
  end

  def line_to_person_a(line) do
    # first get the id_a
    line_to_id_a(line)
    # from that get the person_a
    |> get_person_a()
  end

  @doc """
  given a line/relation, return the label of the person
  """
  def line_to_label(line) do
    line_to_person_a(line).label
  end

  @doc """
  return the entire line_to_id_a map
  """
  def line_to_id_a() do
    Agent.get(:lines_to_id_a, fn map -> map end)
  end

  @doc """
  return the entire id_a to line map
  """
  def id_a_to_line() do
    Agent.get(:id_a_to_lines, fn map -> map end)
  end

  @doc """
  return the lines for an id_a
  """
  def id_a_to_line(id_a) do
    Agent.get(:id_a_to_lines, fn map -> Map.get(map, id_a) end)
  end

end
