defmodule Cfsjksas.Chart.Reduced do
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
    |> draw()
    |> Cfsjksas.Chart.Svg.finish()
    |> Cfsjksas.Chart.Svg.save_file(filename)

  end

  def draw(marked_lineage) do
    gen_list = Enum.to_list(0..14)
    # start svg and pass on to process each generation
    {Cfsjksas.Chart.Svg.beg(), marked_lineage}
    |> draw(gen_list)
  end

  def draw({svg, _lineage}, []) do
    # finished, return svg
    svg
  end
  def draw({svg, lineage}, [0 | rest_gens]) do
    # gen 0 is special case
        # initial circle
    IO.inspect("starting draw.gen=0")
#    cfg = %{
#      gen: 0,
#      sector_num: 0,
#      line_color: "black",
#      fill: "none",
#      fill_opacity: "50%"
#    }
#gen=0
#sector_num = 0
#    sector = Cfsjksas.Chart.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)



    #recurse on
    draw({svg, lineage}, rest_gens)
  end
  def draw({svg, lineage}, [this_gen | rest_gens]) do
IO.inspect(this_gen)

    #recurse on
    draw({svg, lineage}, rest_gens)
  end



end
