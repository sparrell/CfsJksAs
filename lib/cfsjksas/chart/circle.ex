defmodule Cfsjksas.Chart.Circle do
  @moduledoc """
  make circle svg
  """

  def main(filename) do
    # get marked relations data
    Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    # and draw it
    |> Cfsjksas.Chart.Draw.main(:circle_chart)
    |> Cfsjksas.Chart.Svg.finish()
    |> Cfsjksas.Chart.Svg.save_file(filename)

  end

end
