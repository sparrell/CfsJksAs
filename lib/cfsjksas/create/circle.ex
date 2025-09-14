defmodule Cfsjksas.Create.Circle do
  @moduledoc """
  routines for creating SVG Circle Chart
  """
  require IEx

  @doc """
  Input: ancestor matrix map
  Output: svg text for circle diagram
  """
  def main(chart, filename) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)
    case chart in [:circle_base, :circle_ship, :circle_dups, :circle_wo_dups] do
      false ->
        IEx.pry()
      true ->
        IO.inspect("made it to create.circle.main")
      end

    # create matrix and fill it
    Cfsjksas.Tools.Matrix.init_ancestors()
    |> process(chart)
    |> draw(chart)
    |> Cfsjksas.Tools.Print.write_file(filepath)

    IO.inspect(filepath, label: "created chart")
  end

  def process(matrix, _chart) do
    # enchance matrix based on chart and data in matrix
    # no op for now
    matrix
  end

  def draw(matrix, chart)
        when chart in [:circle_base] do
    # do gen 0 special
    gen_list = Enum.to_list(1..10)

    Cfsjksas.Tools.Svg.beg()
    |> draw_gen0()
    |> draw(matrix, gen_list, chart)
    |> Cfsjksas.Tools.Svg.trailer()

  end

  def draw_gen0(svg) do
    # gen zero, ie center circle, is special case
    IO.inspect("starting create.circle, gen=0")

    # initial circle
    gen = 0
    sector_num = 0
    line_color = "black"
    fill = "none"
    fill_opacity = "50%"
    sector = Cfsjksas.Create.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # return svg of initial + circle
    svg <> sector.svg
  end

  def draw(svg, _matrix, [], _chart) do
    # no gens left so done
    svg
  end
  def draw(svg, matrix, [this_gen | rest_gen], chart) do
    # process ancestors in this_gen, then recurse thru others
    gen_total = 2 ** this_gen
    sector_list = Enum.to_list(0..(gen_total - 1))
    # for eact sector in list:
    ##  check if matrix of {this_gen, sector_num} is nil or valid ancestor
    ##  if valid ancestor, draw the sector
    # then recurse thru rest of gens
    svg <> Cfsjksas.Tools.Svg.comment("Generation " <> inspect(this_gen))
    |> draw(matrix, this_gen, sector_list, chart)
    |> draw(matrix, rest_gen, chart)
  end
  def draw(svg, _matrix, _this_gen, [], _chart) do
    # sector list is empty so done
    svg
  end
  def draw(svg, matrix, this_gen, [this_sector_num | rest_sectors], chart) do
    #recurse with new_svg having added (if present) this ancestor's sector
    draw(draw_sector(svg,
                    this_gen,
                    this_sector_num,
                    matrix[{this_gen, this_sector_num}], # this ancestor
                    chart),
        matrix,
        this_gen,
        rest_sectors,
        chart)
  end

  def draw_sector(svg, _this_gen, _sector_num, nil, _chart) do
    # this_ancestor = nil so nothing to draw
    svg
  end
  def draw_sector(svg, gen, sector_num, this_ancestor, _chart) do
    # draw this_ancestor

    line_color = find_line_color(this_ancestor)
    fill = find_fill(this_ancestor)
    fill_opacity = find_fill_opacity(this_ancestor)
    config = Cfsjksas.Create.Get.config(gen)

    # create sector
    sector = Cfsjksas.Create.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # add name
    name = Cfsjksas.Create.Sector.add_name(gen, this_ancestor, sector, config.name_type)


    # draw sector
    svg
    <> Cfsjksas.Tools.Svg.person_comment(this_ancestor)
    <> sector.svg
    <> name

  end

  defp find_line_color(person) do
    case Enum.take(person.relation, -1) do
      ["M"] ->
        "#FF6EC7"
      ["P"] ->
        "blue"
      _ ->
        IEx.pry()
    end
  end

  defp find_fill(person) do
    # return fill if it exists
    Map.get(person, :fill, "none")
  end

  defp find_fill_opacity(person) do
    # return fill opacitey if it exists
    Map.get(person, :fill_opacity, "60%")
  end

end
