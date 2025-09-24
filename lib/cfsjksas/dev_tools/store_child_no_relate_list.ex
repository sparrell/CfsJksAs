defmodule Cfsjksas.DevTools.StoreChildNoWerelateList do
  use Agent

  # start list of people
  def start_link(_) do
    Agent.start_link(fn -> [] end, name: :child_no_werelate_list)
  end

  @spec add_to_list(any()) :: :ok
  def add_to_list(id) do
    Agent.update(:child_no_werelate_list, &([id | &1]))
  end

  # Get the current value of the list
  def get_list() do
    Agent.get(:child_no_werelate_list, & &1)
  end

end
