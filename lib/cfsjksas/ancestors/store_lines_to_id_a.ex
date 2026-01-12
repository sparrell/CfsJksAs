defmodule Cfsjksas.Ancestors.StoreLinesToIdA do
  use Agent

  def start_link(_) do
    lines = Cfsjksas.Ancestors.PeopleToLines.create_lines()

    lines
    |> Cfsjksas.Tools.Print.lines_to_file()

    Agent.start_link(fn -> lines end, name: :lines_to_id_a)

  end

end
