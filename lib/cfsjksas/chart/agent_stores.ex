defmodule Cfsjksas.Chart.AgentStores do
  @moduledoc """
  make 'reduced circle' svg
  ie duplicates removed
  """

  def init() do
    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()

    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: :ancestors)

    Agent.update(:ancestors, fn map -> Map.merge(map, ancestors) end)

    marked_lineages = Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()

    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: :marked_lineages)

    Agent.update(:marked_lineages, fn map -> Map.merge(map, marked_lineages) end)

  end

  def get_person_a(id_a) do
    Agent.get(:ancestors, fn map -> Map.get(map, id_a) end)
  end

  def get_person_m(id_m) do
    Agent.get(:marked_lineages, fn map -> Map.get(map, id_m) end)
  end

  def all_a_ids() do
    Agent.get(:ancestors, fn map -> Map.keys(map) end)
  end

  def all_m_ids() do
    Agent.get(:marked_lineages, fn map -> Map.keys(map) end)
  end

  def m_ids_by_gen(gen) do
    all_m_ids()
    |> Enum.filter(fn {mgen, _quadrant, _sector} ->
      gen == mgen
      end)
  end


end
