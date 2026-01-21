defmodule Cfsjksas.Chart.Circle do
  @moduledoc """
  make circle svg
  """

  def main(filename) do
    # get marked relations data
#    Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
    Cfsjksas.Ancestors.AgentStores.get_marked_sector_map()
# and draw it
    |> Cfsjksas.Chart.Draw.main(:circle_chart)
    |> Cfsjksas.Chart.Svg.save_file(filename, :circle_chart)

  end

end
