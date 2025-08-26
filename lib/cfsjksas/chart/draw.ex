defmodule Cfsjksas.Chart.Draw do
  require IEx

  def main(marked_lineage) do
    gen_list = Enum.to_list(0..14)
    # start svg and pass on to process each generation
    Cfsjksas.Chart.Svg.beg()
    |> draw(marked_lineage, gen_list)
  end
  def draw(svg, _lineage, []) do
    # finished, return svg
    svg
  end
  def draw(svg, lineage, [gen | rest_gens]) do
    cfg = Cfsjksas.Chart.GetCircleMod.config().sector[gen]

    # add generation boundry comment to svg
    boundary = "Generation #{gen}\n"

    svg
    |> Cfsjksas.Chart.Svg.comment(boundary)
    # add in this sector
    |> draw_gen(gen, cfg, lineage)
    # recurse
    |> draw(lineage, rest_gens)
  end

  def draw_gen(svg, _gen, %{layout: :circle} = _cfg, _lineage) do
    # gen 0 circle is special case
    IO.inspect("circle")
    # note circle is special case since only one
    svg
    |> Cfsjksas.Chart.Svg.center_circle()
  end
  def draw_gen(svg, gen, cfg, lineage) do
    keys = Cfsjksas.Tools.Relation.gen_keys(lineage, gen)
    |> Enum.sort()

    # recursse thru the individuals in the generation
    draw_person(svg, gen, cfg, lineage, keys)
  end

  def draw_person(svg, _gen, _cfg, _lineage, []) do
    # no keys left so done
    svg
  end
  def draw_person(svg, gen, cfg, lineage, [id_l | rest_keys]) do
    # determine if this is duplicate to be skipped
    person_l = lineage[id_l]
    id_a = person_l.id
    person_a = Cfsjksas.Ancestors.GetAncestors.person(id_a)

    svg
    |> Cfsjksas.Chart.Svg.draw_sector(id_l, person_l, id_a, person_a, cfg, lineage)
    # recurse to next person
    |> draw_person(gen, cfg, lineage, rest_keys)

  end


end
