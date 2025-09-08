defmodule Cfsjksas.DevTools.StoreUpdatingLink do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :updating_link)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:updating_link, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:updating_link, &(&1 + 1))
  end

end
