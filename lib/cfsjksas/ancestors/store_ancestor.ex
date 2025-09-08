defmodule Cfsjksas.Ancestors.StoreAncestor do
  use Agent

  def start_link(_) do
    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()
    Agent.start_link(fn -> ancestors end, name: :ancestors)
  end

end
