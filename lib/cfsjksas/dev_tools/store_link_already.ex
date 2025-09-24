defmodule Cfsjksas.DevTools.StoreLinkAlready do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :link_already)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:link_already, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:link_already, &(&1 + 1))
  end

end
