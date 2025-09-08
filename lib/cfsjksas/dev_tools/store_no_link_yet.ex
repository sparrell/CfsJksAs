defmodule Cfsjksas.DevTools.StoreNoLinkYet do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :no_link_yet)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:no_link_yet, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:no_link_yet, &(&1 + 1))
  end

end
