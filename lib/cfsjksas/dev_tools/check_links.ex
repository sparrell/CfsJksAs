defmodule Cfsjksas.DevTools.CheckLinks do

  def try1() do
    ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors();:ok
    try1 = "people_try1_ex.txt"
    d = Cfsjksas.DevTools.CompareMaps.diff_map_file(ancestors, try1);:ok
    adds = Map.keys(d.value)
    Enum.each(adds, fn key -> IO.inspect(d.value[key].added)end)
  end

end
