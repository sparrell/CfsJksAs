defmodule Cfsjksas.DevTools.StoreChildNoWerelate do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :child_no_werelate)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:child_no_werelate, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:child_no_werelate, &(&1 + 1))
  end

end
