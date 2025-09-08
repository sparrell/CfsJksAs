defmodule Cfsjksas.DevTools.StoreNoFather do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :no_father)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:no_father, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:no_father, &(&1 + 1))
  end

end
