defmodule Cfsjksas.DevTools.StoreNilPerson do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :nil_person)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:nil_person, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:nil_person, &(&1 + 1))
  end

end
