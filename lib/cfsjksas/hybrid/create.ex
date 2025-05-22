defmodule Cfsjksas.Hybrid.Create do
    @moduledoc """
  routines for creating SVG "hybrid" Chart
  """

  require DateTime
  require IEx



  @doc """
  input: filename
  output: file written with SVG chart

  uses relation file, with duplicate ancestors stripped out
  uses circle chart for inner generations
  kludges outmost generations for readability and to fit
  """
  def main(filename) do
    # get relations data and remove duplicates in it

    {Cfsjksas.Hybrid.Svg.beg(), Cfsjksas.Tools.Relation.dedup()}
    |> draw_gen()
    |> Cfsjksas.Hybrid.Svg.finish()
    |> Cfsjksas.Hybrid.Svg.save_file(filename)

    IO.inspect(filename, label: "created chart")

  end


  def draw_gen({svg, relations}) do
    # initial circle
    IO.inspect("starting draw.gen=0")
    gen = 0
    sector_num = 0
    line_color = "black"
    fill = "none"
    fill_opacity = "50%"
    sector = Cfsjksas.Hybrid.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # go to next generation
    draw_gen({svg <> sector.svg, relations}, 1)
  end
  def draw_gen({svg, relations}, gen) when gen in 0..14 do

    # get list of this gen ancestors
    this_gen_list = Map.keys(relations[gen])
    num_anc = length(this_gen_list)
    IO.inspect({gen, num_anc}, label: "gen = #anc")

    # recurse thru each one.
    new_svg = add_ancestor({relations, svg}, gen, this_gen_list)
    # add in extra lines for special generations (13,14)
    |> xtra_lines(gen)

    # and then go to next up generation
    draw_gen({new_svg, relations}, gen+1)
  end
  def draw_gen({svg, _relations}, 15) do
    # reached top gen so finish returning just svg
    svg
  end

  def add_ancestor({_relations, svg}, _gen, []) do
    # this_gen_list is empty so done
    svg
  end
  def add_ancestor({relations, svg}, gen, [this_relation | rest_in_this_gen]) do
    person = relations[gen][this_relation]

    # determine line color based on whether person is a father or mother
    line_color = Cfsjksas.Hybrid.Get.line_color(this_relation)

    {fill, fill_opacity} = Cfsjksas.Hybrid.Get.fill(person.termination)

        # make shape
    sector = Cfsjksas.Hybrid.Sector.make_shape(gen, person.sector, line_color, fill, fill_opacity)
    svg = svg <> sector.svg

    # add name
    svg = svg <> Cfsjksas.Hybrid.Sector.add_name(gen, person, sector)

    # recurse thru rest of this gen's list
    add_ancestor({relations, svg}, gen, rest_in_this_gen)
  end

  def custom_sector({relations, svg}, gen, [["M", "M", "M", "M", "P", "M", "M", "M", "P", "P", "M", "M", "M"] | rest_in_this_gen]) do

    # recurse thru rest of this gen's list
    custom_sector({relations, svg}, gen, rest_in_this_gen)
  end

  def xtra_lines(svg, gen) when gen in 0..12 do
    # no extra lines, add comment
    svg <> "<!-- End of Generation " <> to_string(gen) <> " -->\n"
  end
  def xtra_lines(svg, 13) do
    # add in connection lines for gen 14
    xtra_lines(svg, 13, Cfsjksas.Hybrid.Get.xtra_lines(13))
  end
  def xtra_lines(svg, 14) do
    # add in connection lines for gen 14
    xtra_lines(svg, 14, Cfsjksas.Hybrid.Get.xtra_lines(14))
  end

  def xtra_lines(svg, 13, []) do
    # out of lines, add comment
    svg <> "<!-- End of Generation " <> to_string(13) <> " -->\n"
  end
  def xtra_lines(svg, 13, [{low, high} | rest]) do
    # add a line from low (ie gen 12) sector's outer arc to
    # high (ie gen 13) sector's inner arc

    # low point's radius
    low_radius = Cfsjksas.Hybrid.Get.radius(12)
    high_radius = low_radius + 100
    beg_radians = (low + 0.5) * 2 * :math.pi() / (2 ** 12)
    end_radians = (high + 0.5) * 2 * :math.pi() / (2 ** 12)

    # low x,y
    {beg_x, beg_y} = Cfsjksas.Hybrid.Get.xy(low_radius, beg_radians)
    {end_x, end_y} = Cfsjksas.Hybrid.Get.xy(high_radius, end_radians)

    # path_id
    path_id = "xtra_13_" <> to_string(low) <> "_" <> to_string(high)

    # add ray to svg and recurse
    svg
    <> "<path id=\"" <> path_id
    <> "\" stroke=\"black\" stroke-width=\"3\" d=\"M "
    <> to_string(beg_x) <> "," <> to_string(beg_y)
    <> " L " <> to_string(end_x) <> "," <> to_string(end_y) <> "\" />\n"
    |> xtra_lines(13, rest)
  end
  def xtra_lines(svg, 14, []) do
    # out of lines, add comment
    svg <> "<!-- End of Generation " <> to_string(14) <> " -->\n"
  end
  def xtra_lines(svg, 14, [{low, high} | rest]) do
    # add a line from low (ie gen 13) sector's outer arc to
    # high (ie gen 14) sector's inner arc

    # low point's radius
    low_radius = Cfsjksas.Hybrid.Get.radius(13)
    high_radius = low_radius + 100
    beg_radians = (low + 0.5) * 2 * :math.pi() / (2 ** 12)
    end_radians = (high + 0.5) * 2 * :math.pi() / (2 ** 12)

    # low x,y
    {beg_x, beg_y} = Cfsjksas.Hybrid.Get.xy(low_radius, beg_radians)
    {end_x, end_y} = Cfsjksas.Hybrid.Get.xy(high_radius, end_radians)

    # path_id
    path_id = "xtra_14_" <> to_string(low) <> "_" <> to_string(high)

    # add ray to svg and recurse
    svg
    <> "<path id=\"" <> path_id
    <> "\" stroke=\"black\" stroke-width=\"3\" d=\"M "
    <> to_string(beg_x) <> "," <> to_string(beg_y)
    <> " L " <> to_string(end_x) <> "," <> to_string(end_y) <> "\" />\n"
    |> xtra_lines(14, rest)
  end

end
