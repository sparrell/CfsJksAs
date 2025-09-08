defmodule Cfsjksas.DevTools.StoreCountPeople do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: :count_people)
  end

  # Get the current value of the counter
  def value do
    Agent.get(:count_people, & &1)
  end

  # Increment the counter by 1
  def increment do
    Agent.update(:count_people, &(&1 + 1))
  end

end
