defmodule Cfsjksas.Chart.Circle do
  @moduledoc """
  make circle svg
  """

  def main(filename) do
    # get marked relations data
    Cfsjksas.Chart.AgentStores.get_marked_lineages()
    # and draw it
    |> Cfsjksas.Chart.Draw.main(:circle_chart)
    |> Cfsjksas.Chart.Svg.finish()
    |> Cfsjksas.Chart.Svg.save_file(filename, :circle_chart)

  end

end
