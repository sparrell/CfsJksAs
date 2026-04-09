defmodule Cfsjksas.DevTools.ListIds do
  def all() do
    Cfsjksas.Ancestors.AgentStores.all_a_ids()
    |> Enum.sort()
    |> IO.inspect(limit: :infinity)

    :ok
  end
end
