defmodule Cfsjksas.Ancestors.StoreMarkedSectors do
  use Agent

  def start_link(_) do
    marked_sectors = Cfsjksas.Tools.Relation.make_marked_sectors()

    marked_sectors
    |> Cfsjksas.Tools.Print.marked_sectors_print()

    Agent.start_link(fn -> marked_sectors end, name: :marked_sectors)
  end

end
