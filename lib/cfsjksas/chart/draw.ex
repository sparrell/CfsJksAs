defmodule Cfsjksas.Chart.Draw do
  require IEx

  def main(marked_lineage, chart_type) do
    gen_list = Enum.to_list(0..14)
    # start svg and pass on to process each generation
    Cfsjksas.Chart.Svg.beg(chart_type)
    |> draw(marked_lineage, gen_list, chart_type)
  end
  def draw(svg, _lineage, [], _chart_type) do
    # finished, return svg
    svg
    |> touchup()
    |> Cfsjksas.Chart.Svg.finish()
  end
  def draw(svg, lineage, [gen | rest_gens], chart_type) do
    cfg = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.config().sector[gen]
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.config().sector[gen]
    end

    # add generation boundry comment to svg
    boundary = "Generation #{gen}\n"

    svg
    |> Cfsjksas.Chart.Svg.comment(boundary)
    # add in this sector
    |> draw_gen(gen, cfg, lineage, chart_type)
    # recurse
    |> draw(lineage, rest_gens, chart_type)
  end

  def draw_gen(svg, _gen, %{layout: :circle} = _cfg, _lineage, chart_type) do
    # gen 0 circle is special case
    svg
    |> Cfsjksas.Chart.Svg.center_circle(chart_type)
  end
  def draw_gen(svg, gen, cfg, lineage, chart_type) do
    keys = Cfsjksas.Tools.Relation.gen_keys(lineage, gen)
    |> Enum.sort()

    # recursse thru the individuals in the generation
    draw_person(svg, gen, cfg, lineage, keys, chart_type)
  end

  def draw_person(svg, _gen, _cfg, _lineage, [], _chart_type) do
    # no keys left so done
    svg
  end
  def draw_person(svg, gen, cfg, lineage, [id_l | rest_keys], chart_type) do
    # determine if this is duplicate to be skipped
    person_l = lineage[id_l]
    id_a = person_l.id
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)

    svg
    |> Cfsjksas.Chart.Svg.draw_sector(id_l, person_l, person_a, cfg, chart_type)
    # recurse to next person
    |> draw_person(gen, cfg, lineage, rest_keys, chart_type)

  end

  defp touchup(svg) do
    # add lines for the adjusted gen 12, 13, 14
    touchup_list = Cfsjksas.Chart.GetCircleMod.touchup_list()
    svg
    |> touchup(touchup_list)
  end
  defp touchup(svg, []) do
    #done
    svg
  end
  defp touchup(svg, [this_line | rest_of_lines]) do
    {{outer_gen, outer_sector}, {inner_gen, inner_sector}} = this_line
    # find the midpoint of inner arc of the outer gen
    outer_radians = (outer_sector + 0.5) * (2 * :math.pi()) / (2**11)
    # find the radius of the inner arc of the outer gen
    outer_radius = Cfsjksas.Chart.GetCircleMod.inner_radius(outer_gen)
    # find x,y for radians/radius
    {outer_x, outer_y} = Cfsjksas.Chart.GetCircleMod.xy(outer_radius, outer_radians)

    # find the midpoint of outer arc of the inner gen
    inner_radians = (inner_sector + 0.5) * (2 * :math.pi()) / (2**11)
    # find the radius of the outer arc of the inner gen
    inner_radius = Cfsjksas.Chart.GetCircleMod.outer_radius(inner_gen)
    # find x,y for radians/radius
    {inner_x, inner_y} = Cfsjksas.Chart.GetCircleMod.xy(inner_radius, inner_radians)

    # create id
    id = "\"g#{outer_gen}_s#{outer_sector}_g#{inner_gen}_s#{inner_sector}\""
    # draw line
    connector = "<line "
    <> "id=#{id} "
    <> "x1=\"#{outer_x}\" y1=\"#{outer_y}\" "
    <> "x2=\"#{inner_x}\" y2=\"#{inner_y}\" "
    <> "stroke=\"gray\" stroke-width=\"5\" />\n"
    touchup(svg <> connector, rest_of_lines)

  end


end
