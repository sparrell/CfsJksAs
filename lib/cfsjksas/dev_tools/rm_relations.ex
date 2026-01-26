defmodule Cfsjksas.DevTools.RmRelations do
  def rm() do
    people = Cfsjksas.Ancestors.AgentStores.get_ancestors()
    people2 = Enum.into(people, %{}, fn {k, person} -> {k, Map.delete(person, :relation_list)} end)
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people2_ex.txt")
    Cfsjksas.Tools.Print.format_ancestor_map(people2)
    |> Cfsjksas.Tools.Print.write_file(filepath)
  end
end
