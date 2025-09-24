defmodule Cfsjksas.DevTools.StoreReset do
  use Agent

  def zero_counts() do
    Agent.update(:count_people, fn _ -> 0 end)
    Agent.update(:child_no_werelate, fn _ -> 0 end)
    Agent.update(:link_already, fn _ -> 0 end)
    Agent.update(:nil_person, fn _ -> 0 end)
    Agent.update(:no_child_map, fn _ -> 0 end)
    Agent.update(:no_father, fn _ -> 0 end)
    Agent.update(:no_mother, fn _ -> 0 end)
    Agent.update(:no_link_yet, fn _ -> 0 end)
    Agent.update(:updating_link, fn _ -> 0 end)
  end

end
