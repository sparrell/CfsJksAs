defmodule Cfsjksas.DevTools.StoreNoChildMap do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :no_child_map)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:no_child_map, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:no_child_map, &(&1 + 1))
  end

end
