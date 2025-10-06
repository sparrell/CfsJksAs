defmodule Cfsjksas.Chart.CircleMod do
  @moduledoc """
  make 'reduced circle' svg
  ie duplicates removed
  """

  def main(filename) do
    # get marked relations data
    Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
    # and draw it
    |> Cfsjksas.Chart.Draw.main(:circle_mod_chart)
    |> Cfsjksas.Chart.Svg.finish()
    |> Cfsjksas.Chart.Svg.save_file(filename, :circle_mod_chart)

  end

end
