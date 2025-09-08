defmodule Cfsjksas.Ancestors.StoreRelationMap do
  use Agent

  def start_link(_) do
    relation_map = Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    |> Cfsjksas.Tools.Relation.make_relation_ids()

    Agent.start_link(fn -> relation_map end, name: :relation_map)
  end

end
