defmodule Cfsjksas.Chart.CircleMod do
  @moduledoc """
  make 'reduced circle' svg
  ie duplicates removed
  """

  def main(filename) do
    # get marked relations data
    Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    # and draw it
    |> Cfsjksas.Chart.Draw.main(:circle_mod_chart)
    |> Cfsjksas.Chart.Svg.finish()
    |> Cfsjksas.Chart.Svg.save_file(filename, :circle_mod_chart)

  end

  def gen_info(gen) do
    # get marked relations data
    Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    |> Enum.filter(fn {{mgen, _quadrant, _sector}, _value} ->
      gen == mgen
      end)
    |> Enum.map(fn {{_gen, _quadrant, sector}, value} ->
      {sector, value.duplicate}
      end)
    |> Enum.filter(fn {_sector, dup} ->
      dup != :redundant
      end)
    |> Enum.map(fn {sector, _dup} ->
      sector
      end)
    |> Enum.sort()
    |> Enum.each(fn sector ->
      IO.inspect("#{sector} => #{sector / 2},")
    end)

  end


end
