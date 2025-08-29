defmodule Cfsjksas.Chart.Svg do

  require DateTime
  require IEx

  def save_file(svgtext, filename, chart_type) do
    filepath = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.path(filename)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.path(filename)
    end

    File.write(filepath, svgtext)
    test_filepath = filepath <> ".txt"
    File.write(test_filepath, svgtext)
  end

  def beg(chart_type) do
    cfg = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.config().svg
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.config().svg
    end

    "<svg "
    <> cfg.size
    <> cfg.viewbox
    <>" xmlns=\"http://www.w3.org/2000/svg\">"
  end

  def finish(svg) do
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

  def comment(svg, text) do
    svg
    <> "\n<!-- " <> text <> " -->"
  end

  def center_circle(svg, chart_type) do
    # gen 0 is special since not a sector but a circle
    cfg = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.config()
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.config()
    end

    r = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.radius(0)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.radius(0)
    end

    ctr_x = cfg.svg.mxc
    ctr_y = cfg.svg.myc

    # some data needed for names
    ## use same x beg and end for each line
    x1 = to_string(ctr_x - round((2 * r) / 3))
    x2 = to_string(ctr_x + round((2 * r) / 3))
    ## vary the y by which line
    ## name 1
    yn1 = to_string(ctr_y - round((1.6 * r) / 3))
    ## date 1
    yd1 = to_string(ctr_y - round((1.2 * r) / 3))
    ## name 2
    yn2 = to_string(ctr_y - round((0.2 * r) / 3))
    ## date 2
    yd2 = to_string(ctr_y + round((0.2 * r) / 3))
    ## name 3
    yn3 = to_string(ctr_y + round((1.2 * r) / 3))
    ## date 3
    yd3 = to_string(ctr_y + round((1.6 * r) / 3))


    # start with existing svg
    svg
    # draw circle
    <> "<circle cx=\"#{ctr_x}\" cy=\"#{ctr_y}\" r=\"#{r}\" "
    # add id
    <> "id=\"ctr_cir \""
    # path color
    <> " stroke=\"#{cfg.sector[0].line_color}\" "
    # path width
    <> " stroke-width=\"#{cfg.sector[0].stroke_width}\""
    # fill color
    <> " fill=\"#{cfg.sector[0].fill}\" "
    # fill opacity
    <> " fill-opacity=\"#{cfg.sector[0].fill_opacity}\" "
    # close svg item
    <> " />\n"

    # add invisible lines to put names/dates on
    ## name 1 line, id = g0_name1
    ## horizontal line 1/3 above center, 2/3 width
    ## y = ctr_y MINUS (positive is down) 1/3 * radius
    ## x = ctr_y plus 1/3 * radius to ctr_y minus 1/3 * radius

    ## add name 1
    <> make_hidden_line("g0_name1", x1, yn1, x2, yn1)
    <> make_name_text("g0_name1", cfg.sector[0].font_size1, cfg.sector[0].name1)

    # add date 1
    <> make_hidden_line("g0_date1", x1, yd1, x2, yd1)
    <> make_name_text("g0_date1", cfg.sector[0].font_size2, cfg.sector[0].date1)

    # name 2
    <> make_hidden_line("g0_name2", x1, yn2, x2, yn2)
    <> make_name_text("g0_name2", cfg.sector[0].font_size1, cfg.sector[0].name2)

    # add date 2
    <> make_hidden_line("g0_date2", x1, yd2, x2, yd2)
    <> make_name_text("g0_date2", cfg.sector[0].font_size2, cfg.sector[0].date2)

    # name 3
    <> make_hidden_line("g0_name3", x1, yn3, x2, yn3)
    <> make_name_text("g0_name3", cfg.sector[0].font_size1, cfg.sector[0].name3)

    # add date 3
    <> make_hidden_line("g0_date3", x1, yd3, x2, yd3)
    <> make_name_text("g0_date3", cfg.sector[0].font_size2, cfg.sector[0].date3)

  end

  def draw_sector(svg, _id_l,
        %{duplicate: :redundant} = _person_l,
        _person_a, _cfg, :circle_mod_chart) do
    # if redundant duplicate, and chart_type is circle_mod, don't add sector
    svg
  end
  def draw_sector(svg, id_l, person_l, person_a, cfg, chart_type) do
    # draw shape for this person
    Cfsjksas.Chart.Sector.make(id_l, person_l, person_a, cfg, chart_type)
    |> make_shape_svg(svg, chart_type)

  end

  defp make_hidden_line(id, x1, y1, x2, y2) do
    "<path id=\"" <> id <> "\" "
    <> "d=\"M " <> x1 <> " " <> y1 <> " "
    <> "L" <> x2 <> " " <> y2 <> "\" "
    <> " />\n"
  end

def make_hidden_arc(id, r, beg_x, beg_y, end_x, end_y, sweep) do
  # rotation is always set to zero
  rot = "0"
  # large_arc is always set to zero
  large_arc = "0"

  "<path id=\"" <> to_string(id) <> "\" fill = \"none\" "
  <> " d=\"M " <> to_string(end_x) <> "," <> to_string(end_y)
  <> " A " <> to_string(r) <> "," <> to_string(r)
  <> " " <> rot <> " " <> large_arc <> "," <> sweep
  <> " " <> to_string(beg_x) <> "," <> to_string(beg_y) <> "\" />\n"
end

defp make_name_text(id, font_size, text) do
    # add text to exiting path

    "<text style=\"font-family: sans-serif; font-size:" <> font_size <> "; fill:#000000;\">\n"
    <> "<textPath href=\"#" <> id <> "\" startOffset=\"50%\" dominant-baseline=\"middle\" text-anchor=\"middle\">\n"
    <> text <> "\n"
    <> "</textPath>\n"
    <> "</text>\n"
  end

  defp make_hidden_ray(id, beg_x, beg_y, end_x, end_y) do
    # draw straight line
    "<path id=\"" <> id <> "\" d=\"M "
    <> to_string(beg_x) <> "," <> to_string(beg_y)
    <> " L " <> to_string(end_x) <> "," <> to_string(end_y) <> "\" />\n"
  end

  defp make_shape_svg(sector, svg, chart_type) do

    # make shape svg
    ## consists of defs to define path and clipping path
    ## and use to use path and clipping path
    # example
    # <defs>
    #   <path id="sector_3_2" d="M 22041,22041 A 4185,4185 0 0 1 25000,20815 L 25000,21800 A 3200,3200 0 0 0 22737,22737 L 22041,22041" />
    #   <clipPath id="sector_3_2_clip">
    #     <use href="#sector_3_2"/>
    #   </clipPath>
    # </defs>
    # <use href="#sector_3_2" stroke="red" stroke-width="50" fill="none" fill-opacity="0%" clip-path="url(#sector_3_2_clip)"/>

    clip_id = sector.id <> "_clip"

    # start at point A
    ## make arc to point B along outer radius,
    ### arcs have both an x radii and a y radii which are equal here
    ### arcs have a rotation which is zero here
    ### arcs have a "large_are" which we always take the short arc
    ### arcs have a "sweep" which is 1
    ### end arc at b
    ## make ray to point D,
    ## make arc along inner_radius to point C,
    ### note this arc is "going opposite" so reverse the sweep
    ## make ray to point A, closing shape

    svg
    <> "<defs>\n"
    <> "<path id=\"#{sector.id}\" d=\"M #{sector.a_x} #{sector.a_y} "
    <> "A #{sector.outer_radius} #{sector.outer_radius} 0 0 1 #{sector.b_x} #{sector.b_y} "
    <> "L #{sector.d_x} #{sector.d_y} "
    <> "A #{sector.inner_radius} #{sector.inner_radius} 0 0 0 #{sector.c_x} #{sector.c_y} "
    <> "L #{sector.a_x} #{sector.a_y} "
    <> "\" />\n"
    <> "<clipPath id=\"#{clip_id}\">\n"
    <> "<use href=\"##{sector.id}\"/>\n"
    <> "</clipPath>"
    <> "</defs>\n"
    <> "<use href=\"##{sector.id}\" "
    <> "stroke=\"#{sector.line_color}\" "
    <> "stroke-width=\"#{sector.stroke_width}\" "
    <> "fill=\"#{sector.fill}\" "
    <> "fill-opacity=\"#{sector.fill_opacity}\" "
    <> "clip-path=\"url(##{clip_id})\"/>\n"
    # add name
    <> add_name(sector, chart_type)
  end

  def add_name(%{layout: :arc1} = sector, chart_type) do
    # all on one line
    text = "#{sector.given_name} #{sector.surname} "
    <> "(#{sector.birth_year} - #{sector.death_year})"

    # make hidden arc to put text on
    id = "arc_g#{sector.gen}_s#{sector.sector_num}"

    # draw the arc 50% of the way between inner and outer arcs
    r = sector.inner_radius + round(0.5 * (sector.outer_radius - sector.inner_radius))
    # whether to reverse arc is dependent on quadrant
    {beg_x, beg_y, end_x, end_y} = arc_ends(sector.quadrant, r, sector.lower_radians, sector.upper_radians, chart_type)
    # sweep is dependent on quadrant
    sweep = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.quadrant_sweep(sector.quadrant)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.quadrant_sweep(sector.quadrant)
    end

    font_size = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.config().sector[sector.gen].font_size
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.config().sector[sector.gen].font_size
    end

    make_hidden_arc(id, r, beg_x, beg_y, end_x, end_y, sweep)
    <> make_name_text(id, font_size, text)

  end
  def add_name(%{layout: :arc2} = sector, chart_type) do
  # two arc lines = name and date
  name = sector.given_name <> " " <> sector.surname
  dates = " (" <> sector.birth_year <> " - " <> sector.death_year <> ")"

  # make hidden arcs to put text on
  id_n = "arc_g#{sector.gen}_s#{sector.sector_num}_n"
  id_d = "arc_g#{sector.gen}_s#{sector.sector_num}_d"

  # draw the two arcs 1/3 and 2/3 of the way between the inner and outer arcs
  # sweep is dependent on quadrant
  sweep = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.quadrant_sweep(sector.quadrant)
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.quadrant_sweep(sector.quadrant)
  end

  # diff font sizes for name and date
  config = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.config().sector[sector.gen]
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.config().sector[sector.gen]
  end
  font_size_n = config.font_size_n
  font_size_d = config.font_size_d

  # which is name/date depends on quadrant
  {name_ratio, date_ratio} = case sector.quadrant do
    :ne ->
      {0.66, 0.33}
    :nw ->
      {0.66, 0.33}
    :sw ->
      {0.33, 0.66}
    :se ->
      {0.33, 0.66}
  end
  r_n = sector.inner_radius + round(name_ratio * (sector.outer_radius - sector.inner_radius))
  r_d = sector.inner_radius + round(date_ratio * (sector.outer_radius - sector.inner_radius))

  {beg_x_n, beg_y_n, end_x_n, end_y_n} = arc_ends(sector.quadrant, r_n, sector.lower_radians, sector.upper_radians, chart_type)
  {beg_x_d, beg_y_d, end_x_d, end_y_d} = arc_ends(sector.quadrant, r_d, sector.lower_radians, sector.upper_radians, chart_type)

  make_hidden_arc(id_n, r_n, beg_x_n, beg_y_n, end_x_n, end_y_n, sweep)
  <> make_name_text(id_n, font_size_n, name)
  <> make_hidden_arc(id_d, r_d, beg_x_d, beg_y_d, end_x_d, end_y_d, sweep)
  <> make_name_text(id_d, font_size_d, dates)
  end
  def add_name(%{layout: :arc3} = sector, chart_type) do
  # three arc lines = given_name, surname, and dates
  gname = sector.given_name
  sname = sector.surname
  dates = " (" <> sector.birth_year <> " - " <> sector.death_year <> ")"

  # make hidden arcs to put text on
  id_g = "arc_g#{sector.gen}_s#{sector.sector_num}_g"
  id_s = "arc_g#{sector.gen}_s#{sector.sector_num}_s"
  id_d = "arc_g#{sector.gen}_s#{sector.sector_num}_d"

  # draw the three arcs 1/4, 1/2, and 3/4 of the way between the inner and outer arcs
  # sweep is dependent on quadrant
  sweep = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.quadrant_sweep(sector.quadrant)
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.quadrant_sweep(sector.quadrant)
  end

  # diff font sizes for names and date
  config = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.config().sector[sector.gen]
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.config().sector[sector.gen]
  end

  font_size_n = config.font_size_n
  font_size_d = config.font_size_d

  # in to out order depends on quadrant
  {g_ratio, s_ratio, date_ratio} = case sector.quadrant do
    :ne ->
      {0.75, 0.5, 0.25}
    :nw ->
      {0.75, 0.5, 0.25}
    :sw ->
      {0.25, 0.5, 0.75}
    :se ->
      {0.25, 0.5, 0.75}
  end
  r_g = sector.inner_radius + round(g_ratio * (sector.outer_radius - sector.inner_radius))
  r_s = sector.inner_radius + round(s_ratio * (sector.outer_radius - sector.inner_radius))
  r_d = sector.inner_radius + round(date_ratio * (sector.outer_radius - sector.inner_radius))

  {beg_x_g, beg_y_g, end_x_g, end_y_g} = arc_ends(sector.quadrant, r_g, sector.lower_radians, sector.upper_radians, chart_type)
  {beg_x_s, beg_y_s, end_x_s, end_y_s} = arc_ends(sector.quadrant, r_s, sector.lower_radians, sector.upper_radians, chart_type)
  {beg_x_d, beg_y_d, end_x_d, end_y_d} = arc_ends(sector.quadrant, r_d, sector.lower_radians, sector.upper_radians, chart_type)

  make_hidden_arc(id_g, r_g, beg_x_g, beg_y_g, end_x_g, end_y_g, sweep)
  <> make_name_text(id_g, font_size_n, gname)
  <> make_hidden_arc(id_s, r_s, beg_x_s, beg_y_s, end_x_s, end_y_s, sweep)
  <> make_name_text(id_s, font_size_n, sname)
  <> make_hidden_arc(id_d, r_d, beg_x_d, beg_y_d, end_x_d, end_y_d, sweep)
  <> make_name_text(id_d, font_size_d, dates)
  end
  def add_name(%{layout: :ray1} = sector, chart_type) do
    # name on ray, 1-line

  text = not_nil(sector.given_name) <> " "
  <> not_nil(sector.surname) <> " ("
  <> not_nil(sector.birth_year) <> " - "
  <> not_nil(sector.death_year) <> ")"

  # make hidden arcs to put text on
  id = "ray_g#{sector.gen}_s#{sector.sector_num}"

  # draw the arc 1/2 way between the inner and outer rays
  ## get config
  config = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.config().sector[sector.gen]
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.config().sector[sector.gen]
  end


  font_size = config.font_size

  r_inner = sector.inner_radius
  r_outer = sector.outer_radius
  lower_radians = sector.lower_radians
  # adjust for completing circle
  upper_radians = case sector.upper_radians == 0.0 do
    true ->
        2 * :math.pi()
    false ->
      sector.upper_radians
  end
  phi = (lower_radians + upper_radians) / 2.0

  {inner_x, inner_y} = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.xy(r_inner, phi)
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.xy(r_inner, phi)
  end
  {outer_x, outer_y} = case chart_type do
    :circle_chart ->
      Cfsjksas.Chart.GetCircle.xy(r_outer, phi)
    :circle_mod_chart ->
      Cfsjksas.Chart.GetCircleMod.xy(r_outer, phi)
  end

  # in to out order depends on quadrant
  {beg_x, beg_y, end_x, end_y} = case sector.quadrant do
    :ne ->
      {inner_x, inner_y, outer_x, outer_y}
    :nw ->
      {outer_x, outer_y, inner_x, inner_y}
    :sw ->
      {outer_x, outer_y, inner_x, inner_y}
    :se ->
      {inner_x, inner_y, outer_x, outer_y}
  end

  make_hidden_ray(id, beg_x, beg_y, end_x, end_y)
  <> make_name_text(id, font_size, text)
  end

  defp arc_ends(quadrant, r, angle1, angle2, chart_type)
      when quadrant in [:ne, :nw] do
    # arc begins at lower_radians and ends at upper_radians
    # so that words have right orientation

    {beg_x, beg_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(r, angle1)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(r, angle1)
    end
    {end_x, end_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(r, angle2)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(r, angle2)
    end
    {beg_x, beg_y, end_x, end_y}
  end
  defp arc_ends(quadrant, r, angle1, angle2, chart_type)
      when quadrant in [:se, :sw] do
    # arc begins at upper_radians and ends at lower_radians
    # so that words have right orientation
    {beg_x, beg_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(r, angle2)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(r, angle2)
    end
    {end_x, end_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(r, angle1)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(r, angle1)
    end
    {beg_x, beg_y, end_x, end_y}
  end
  defp arc_ends(quadrant, r, angle1, angle2, chart_type) do
    IO.inspect({quadrant, r, angle1, angle2, chart_type}, label: "arc_ends bad input")
    IEx.pry()
  end

  defp not_nil(input) when is_binary(input) do
    # is string so return as is
    input
  end
  defp not_nil(input) when is_nil(input) do
  # is empty so return blank space (maybe should return question mark?)
  " "
  end




end
