defmodule Cfsjksas.Ancestors.AgentStores do
  @moduledoc """
  routines for accessing data in the Agent storage
  - get_ancestors()
        get entire ancestor map
  - get_person_a(id_a)
        get one person from ancestor
  - all_a_ids()
        get list of all ancestor id's
  - get_marked_lineages()
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
  - id_a_by_gen()
        list of ancestor id's sorted by generation of 'main' marked lineag
  """

  @doc """
  """

  def get_ancestors() do
    Agent.get(:ancestors, fn map -> map end)
  end

  def get_person_a(id_a) do
    Agent.get(:ancestors, fn map -> Map.get(map, id_a) end)
  end

  def all_a_ids() do
    Agent.get(:ancestors, fn map -> Map.keys(map) end)
    |> Enum.sort()
  end

  def get_marked_lineages() do
    Agent.get(:marked_lineages, fn map -> map end)

  end
  def get_person_m(id_m) do
    Agent.get(:marked_lineages, fn map -> Map.get(map, id_m) end)
  end

  def all_m_ids() do
    # helper
    quad_order = %{ne: 0, se: 1, nw: 2, sw: 3}

    Agent.get(:marked_lineages, fn map -> Map.keys(map) end)
    |> Enum.sort_by(fn {gen, quad, sect} ->
      {gen, Map.fetch!(quad_order, quad), sect}
    end)
  end

  @doc """
  list all the m_id's in a generation
  """
  def m_ids_by_gen(gen) do
    # helper
    quad_order = %{ne: 0, se: 1, nw: 2, sw: 3}

    all_m_ids()
    |> Enum.filter(fn
      {^gen, _quadrant, _sector} -> true
      _ -> false
    end)
    |> Enum.sort_by(fn {gen, quad, sect} ->
      {gen, Map.fetch!(quad_order, quad), sect}
    end)
  end

  def get_relation_map() do
    Agent.get(:relation_map, fn map -> map end)
  end

  def get_person_r(id_r) do
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

end
