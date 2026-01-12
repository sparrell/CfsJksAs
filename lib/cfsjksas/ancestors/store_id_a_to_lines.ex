defmodule Cfsjksas.Ancestors.StoreIdAToLines do
  use Agent

  def start_link(_) do
    id_a_to_lines = Cfsjksas.Ancestors.AgentStores.line_to_id_a()
    |> Cfsjksas.Ancestors.LinesToPeople.create_map()

    id_a_to_lines
    |> Cfsjksas.Tools.Print.id_a_to_lines_to_file()

    Agent.start_link(fn -> id_a_to_lines end, name: :id_a_to_lines)

  end

end
