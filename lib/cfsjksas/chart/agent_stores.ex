defmodule Cfsjksas.Chart.AgentStores do
  @moduledoc """
  make 'reduced circle' svg
  ie duplicates removed
  """

  @doc """
  creates agents for 3 data stores:
  - :ancestors
  - :marked_lineages
  - :relation_ids
  """
  def init() do
    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()
    {:ok, _pid} = Agent.start_link(fn -> ancestors end, name: :ancestors)

    marked_lineages = Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    {:ok, _pid} = Agent.start_link(fn -> marked_lineages end, name: :marked_lineages)

    relation_map = Cfsjksas.Tools.Relation.make_relation_ids(marked_lineages)
    {:ok, _pid} = Agent.start_link(fn -> relation_map end, name: :relation_map)

  end

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
    |> Enum.sort()
  end

end
