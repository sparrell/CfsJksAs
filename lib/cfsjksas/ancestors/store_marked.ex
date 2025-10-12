defmodule Cfsjksas.Ancestors.StoreMarked do
  use Agent

  def start_link(_) do
    marked_lineages = Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()

    marked_lineages
    |> Cfsjksas.Tools.Print.marked_print()

    Agent.start_link(fn -> marked_lineages end, name: :marked_lineages)
  end

end
