defmodule Cfsjksas.Hybrid.Sector do
    @moduledoc """

    Sector is main Struct of this module
    Main functions:
    * make_shape - makes the sector shape; calls:
      new_struct
      |> add_id()
      |> add_quadrant()
      |> add_reverse()
      |> add_inner_radius()
      |> add_outer_radius()
      |> add_lower_radians()
      |> add_upper_radians()
      |> add_points()
      |> add_svg - which calls
          make_hidden_arc
          make_hidden_ray
          make_name_text


    Each "sector" is shape for a person.
    A generation has 2**gen sectors, numbered from the x-axis.
    A sector is identified by the generation and the sector number.
    A sector is a closed shape which consists of 4 joined paths:
    - inner arc
    - outer arc
    - lower ray
    - upper ray
    These are defined by 4 points.
            A-------------B
              \          /
                C       D
    Point A:
      - 'higher' end on 'outer arc'
      - 'outside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point B:
      - 'lower' end on 'outer arc'
      - 'outside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Point C:
      - 'higher' end on 'inner arc'
      - 'inside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point D:
      - 'lower' end on 'inner arc'
      - 'inside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Arc AB is the outer_arc
    Arc CD is the inner_arc
    Ray CA is the higher_ray
    Ray DB is the lower_ray

    struct:
      - holds all the necessary data for the sector
    functions:
      - make_shape makes the 4 segments into one path as a filled object

    """


  defstruct [
    id: "need",
    gen: 0,
    sector_num: 0,
    line_color: "black",
    stroke_width: "50",
    fill: "none",
    fill_opacity: "50%",
    quadrant: :ne,
    reverse: false,
    inner_radius: 100,
    outer_radius: 200,
    lower_radians: 0,
    upper_radians: :math.pi(),
    a_x: 0,
    a_y: 0,
    b_x: 0,
    b_y: 0,
    c_x: 0,
    c_y: 0,
    d_x: 0,
    d_y: 0,
    svg: "",
    namelines: %{}
  ]

  @type t() :: %__MODULE__{
    id: String.t(),
    gen: integer(),
    sector_num: integer(),
    line_color: String.t(),
    stroke_width: String.t(),
    fill: String.t(),
    fill_opacity: String.t(),
    quadrant: atom(),
    reverse: boolean(),
    inner_radius: integer(),
    outer_radius: integer(),
    lower_radians: integer(),
    upper_radians: float(),
    a_x: integer(),
    a_y: integer(),
    b_x: integer(),
    b_y: integer(),
    c_x: integer(),
    c_y: integer(),
    d_x: integer(),
    d_y: integer(),
    svg: String.t(),
    namelines: map()
  }

  #@spec make_shape(integer(), integer(), String.t(), String.t(), String.t()) :: Cfsjksas.Hybrid.Sector.t()
  def make_shape(gen, sector_num, line_color, fill, fill_opacity)
      when gen in 0..12 do
    # make sector
    ## inputs: gen, sector, line_color, fill
    ### line_color \\ "black", fill \\ "none", fill_opacity \\ "50%"

    new_struct(gen, sector_num, line_color, fill, fill_opacity)
    |> add_id()
    |> add_quadrant()
    |> add_reverse()
    |> add_inner_radius()
    |> add_outer_radius()
    |> add_lower_radians()
    |> add_upper_radians()
    |> add_points()
    |> add_svg()

  end
    def make_shape(13, sector_num, line_color, fill, fill_opacity) do
    new_struct(13, sector_num, line_color, fill, fill_opacity)
    |> add_id()
    |> add_quadrant()
    |> add_reverse()
    |> add_g13()
#    |> add_inner_radius() # adjust
#    |> add_outer_radius() # adjust
    |> add_lower_radians() # adjust
    |> add_upper_radians() # adjust
    |> add_points()
    |> add_svg()
    end
    def make_shape(14, sector_num, line_color, fill, fill_opacity) do
    new_struct(14, sector_num, line_color, fill, fill_opacity)
    |> add_id()
    |> add_quadrant()
    |> add_reverse()
    |> add_inner_radius()
    |> add_outer_radius()
    |> add_lower_radians()
    |> add_upper_radians()
    |> add_points()
    |> add_svg()
    end

  #@spec new_struct(integer(), integer(), String.t(), String.t(), String.t()) :: Cfsjksas.Hybrid.Sector.t()
  defp new_struct(gen, sector_num, line_color, fill, fill_opacity) do
    %Cfsjksas.Hybrid.Sector{gen: gen, sector_num: sector_num,
      line_color: line_color, fill: fill, fill_opacity: fill_opacity}
  end

  #@spec add_id(Cfsjksas.Hybrid.Sector.t()) :: Cfsjksas.Hybrid.Sector.t()
  defp add_id(sector) do
    id = "sector_" <> to_string(sector.gen) <> "_" <> to_string(sector.sector_num)
    %Cfsjksas.Hybrid.Sector{sector | id: id}
  end

  defp add_quadrant(sector) do
    total_sectors = 2 ** sector.gen
    quadrant = cond do
      sector.sector_num < (total_sectors / 4) -> :ne
      sector.sector_num < (total_sectors / 2) -> :nw
      sector.sector_num < (total_sectors * 3 / 4) -> :sw
      true -> :se
    end
    %Cfsjksas.Hybrid.Sector{sector | quadrant: quadrant}
  end

  defp add_reverse(sector) do
    %Cfsjksas.Hybrid.Sector{sector | reverse: quadrant_reverse(sector.quadrant)}
  end

  defp quadrant_reverse(:ne) do
    true
  end
  defp quadrant_reverse(:nw) do
    true
  end
  defp quadrant_reverse(:sw) do
    false
  end
  defp quadrant_reverse(:se) do
    false
  end

  def add_g13(sector) do
    {inner_radius, outer_radius} = Cfsjksas.Hybrid.Get.hybrid_g13()
    %Cfsjksas.Hybrid.Sector{sector | inner_radius: inner_radius, outer_radius: outer_radius}
  end

  defp add_inner_radius(sector) do
    inner_radius = Cfsjksas.Hybrid.Get.radius(sector.gen - 1)
    %Cfsjksas.Hybrid.Sector{sector | inner_radius: inner_radius }
  end

  defp add_outer_radius(sector) do
    outer_radius = Cfsjksas.Hybrid.Get.radius(sector.gen)
    %Cfsjksas.Hybrid.Sector{sector | outer_radius: outer_radius }
  end

  defp add_lower_radians(sector) do
    lower_radians = sector.sector_num * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Hybrid.Sector{sector | lower_radians: lower_radians }
  end

  defp add_upper_radians(sector) do
    upper_radians = rem(sector.sector_num + 1, 2**sector.gen) * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Hybrid.Sector{sector | upper_radians: upper_radians }
  end

  defp add_points(sector) do
    # point a is outer_radius, upper_radians
    {a_x, a_y} = Cfsjksas.Hybrid.Get.xy(sector.outer_radius, sector.upper_radians)
    # point b is outer_radius, lower_radians
    {b_x, b_y} = Cfsjksas.Hybrid.Get.xy(sector.outer_radius, sector.lower_radians)
    # point c is inner_radius, upper_radians
    {c_x, c_y} = Cfsjksas.Hybrid.Get.xy(sector.inner_radius, sector.upper_radians)
    # point d is inner_radius, lower_radians
    {d_x, d_y} = Cfsjksas.Hybrid.Get.xy(sector.inner_radius, sector.lower_radians)

    %Cfsjksas.Hybrid.Sector{sector | a_x: a_x, a_y: a_y,
                                b_x: b_x, b_y: b_y,
                                c_x: c_x, c_y: c_y,
                                d_x: d_x, d_y: d_y }
  end

  defp add_svg(sector) when sector.gen == 0 do
    IO.inspect("starting add_svg gen=0")

    # gen 0 is special since not a sector but a circle

    {ctr_x, ctr_y} = Cfsjksas.Hybrid.Get.center
    r = Cfsjksas.Hybrid.Get.radius(sector.gen)

    # get necessary info
    config = Cfsjksas.Hybrid.Get.config(sector.gen)

    # draw circle
    svg = "<circle cx=\""
    <> to_string(ctr_x)
    <> "\" cy=\""
    <> to_string(ctr_y)
    <> "\" r=\""
    <> to_string(r)
    <> "\" "

    # add id
    svg = svg <> "id=\"" <> sector.id <> "\""

    # path color
    svg = svg <> " stroke=" <> "\"" <> sector.line_color <> "\""

    # path width
    svg = svg <> " stroke-width=" <> "\"" <> config.stroke_width <> "\""

    # fill color
    svg = svg <> " fill=" <> "\"" <> sector.fill <> "\""

    # fill opacity
    svg = svg <> " fill-opacity=" <> "\"" <> sector.fill_opacity <> "\""

    # close svg item
    svg = svg <> " />\n"

    # add invisible lines to put names/dates on
    ## name 1 line, id = g0_name1
    ## horizontal line 1/3 above center, 2/3 width
    ## y = ctr_y MINUS (positive is down) 1/3 * radius
    ## x = ctr_y plus 1/3 * radius to ctr_y minus 1/3 * radius

    # use same x beg and end for each line
    x1 = to_string(ctr_x - round((2 * r) / 3))
    x2 = to_string(ctr_x + round((2 * r) / 3))

    # vary the y by which line
    # add name 1
    y = to_string(ctr_y - round((1.6 * r) / 3))
    svg = svg <> make_hidden_line("g0_name1", x1, y, x2, y)
    svg = svg <> make_name_text("g0_name1", config.font_size1, config.name1)

    # add date 1
    y = to_string(ctr_y - round((1.2 * r) / 3))
    svg = svg <> make_hidden_line("g0_date1", x1, y, x2, y)
    svg = svg <> make_name_text("g0_date1", config.font_size2, config.date1)

    # name 2
    y = to_string(ctr_y - round((0.2 * r) / 3))
    svg = svg <> make_hidden_line("g0_name2", x1, y, x2, y)
    svg = svg <> make_name_text("g0_name2", config.font_size1, config.name2)

    # add date 2
    y = to_string(ctr_y + round((0.2 * r) / 3))
    svg = svg <> make_hidden_line("g0_date2", x1, y, x2, y)
    svg = svg <> make_name_text("g0_date2", config.font_size2, config.date2)

    # name 3
    y = to_string(ctr_y + round((1.2 * r) / 3))
    svg = svg <> make_hidden_line("g0_name3", x1, y, x2, y)
    svg = svg <> make_name_text("g0_name3", config.font_size1, config.name3)

    # add date 3
    y = to_string(ctr_y + round((1.6 * r) / 3))
    svg = svg <> make_hidden_line("g0_date3", x1, y, x2, y)
    svg = svg <> make_name_text("g0_date3", config.font_size2, config.date3)

    %Cfsjksas.Hybrid.Sector{sector | svg: svg}
  end

  defp add_svg(sector) do
    # add svg for the closed shape
    # start at point A,
    ## make arc to point B,
    ## make ray to point D,
    ## make arc to point C,
    ## make ray to point A and close

    # get necessary info
    config = Cfsjksas.Hybrid.Get.config(sector.gen)
    id = sector.id


    svg = make_shape_svg(id,
                      sector.a_x, sector.a_y,
                      sector.b_x, sector.b_y,
                      sector.c_x, sector.c_y,
                      sector.d_x, sector.d_y,
                      sector.inner_radius,
                      sector.outer_radius,
                      sector.line_color,
                      config.stroke_width,
                      sector.fill,
                      sector.fill_opacity
                      )

    %Cfsjksas.Hybrid.Sector{sector | svg: svg}
  end

  defp make_hidden_line(id, x1, y1, x2, y2) do
    "<path id=\"" <> id <> "\" "
    <> "d=\"M " <> x1 <> " " <> y1 <> " "
    <> "L" <> x2 <> " " <> y2 <> "\" "
    <> " />\n"
  end

  def make_shape_svg(id, a_x, a_y, b_x, b_y, c_x, c_y, d_x, d_y,
                    inner_radius, outer_radius,
                    line_color, stroke_width, fill, fill_opacity
                    ) do

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

    clip_id = id <> "_clip"

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

    "<defs>\n"
    <> "<path id=\"" <> id <> "\" d=\"M "
    <> to_string(a_x) <> "," <> to_string(a_y)
    <> " A " <> to_string(outer_radius) <> "," <> to_string(outer_radius)
    <> " 0 0 1 "
    <> to_string(b_x) <> "," <> to_string(b_y)
    <> " L " <> to_string(d_x) <> "," <> to_string(d_y)
    <> " A " <> to_string(inner_radius) <> "," <> to_string(inner_radius)
    <> " 0 0 0 "
    <> to_string(c_x) <> "," <> to_string(c_y)
    <> " L " <> to_string(a_x) <> "," <> to_string(a_y)
    <> "\" />\n"
    <> "<clipPath id=\"" <> clip_id <> "\">\n"
    <> "<use href=\"#" <> id <> "\"/>\n"
    <> "</clipPath>"
    <> "</defs>"
    <> "<use href=\"#" <> id <> "\" "
    <> "stroke=\"" <> line_color <> "\" "
    <> "stroke-width=\"" <> stroke_width <> "\" "
    <> "fill=\"" <> fill <> "\" "
    <> "fill-opacity=\"" <> fill_opacity <> "\" "
    <> "clip-path=\"url(#" <> clip_id <> ")\"/>\n"
end

def add_name(gen, person, sector) when gen in 1..2 do
  # all on one line
  text = person.given_name <> " "
  <> person.surname <> " ("
  <> person.birth_year <> " - "
  <> person.death_year <> ")"

  # make hidden arc to put text on
  id = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector)

  # draw the arc 50% of the way between inner and outer arcs
  r = sector.inner_radius + round(0.5 * (sector.outer_radius - sector.inner_radius))
  # whether to reverse arc is dependent on quadrant
  {beg_x, beg_y, end_x, end_y} = arc_ends(sector.quadrant, r, sector.lower_radians, sector.upper_radians)
  # sweep is dependent on quadrant
  sweep = Cfsjksas.Hybrid.Get.quadrant_sweep(sector.quadrant)
  font_size = Cfsjksas.Hybrid.Get.config(gen).font_size

  make_hidden_arc(id, r, beg_x, beg_y, end_x, end_y, sweep)
  <> make_name_text(id, font_size, text)

end
def add_name(gen, person, sector) when gen == 3 do
  # two arc lines = name and date
  name = person.given_name <> " " <> person.surname
  dates = " (" <> person.birth_year <> " - " <> person.death_year <> ")"

  # make hidden arcs to put text on
  id_n = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector) <> "_n"
  id_d = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector) <> "_d"

  # draw the two arcs 1/3 and 2/3 of the way between the inner and outer arcs
  # sweep is dependent on quadrant
  sweep = Cfsjksas.Hybrid.Get.quadrant_sweep(sector.quadrant)
  # diff font sizes for name and date
  config = Cfsjksas.Hybrid.Get.config(gen)
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

  {beg_x_n, beg_y_n, end_x_n, end_y_n} = arc_ends(sector.quadrant, r_n, sector.lower_radians, sector.upper_radians)
  {beg_x_d, beg_y_d, end_x_d, end_y_d} = arc_ends(sector.quadrant, r_d, sector.lower_radians, sector.upper_radians)

  make_hidden_arc(id_n, r_n, beg_x_n, beg_y_n, end_x_n, end_y_n, sweep)
  <> make_name_text(id_n, font_size_n, name)
  <> make_hidden_arc(id_d, r_d, beg_x_d, beg_y_d, end_x_d, end_y_d, sweep)
  <> make_name_text(id_d, font_size_d, dates)

end
def add_name(gen, person, sector) when gen in 4..6 do
  # three arc lines = given_name, surname, and dates
  gname = person.given_name
  sname = person.surname
  dates = " (" <> person.birth_year <> " - " <> person.death_year <> ")"

  # make hidden arcs to put text on
  id_g = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector) <> "_g"
  id_s = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector) <> "_s"
  id_d = "arc_g" <> to_string(gen) <> "_s" <> to_string(person.sector) <> "_d"

  # draw the three arcs 1/4, 1/2, and 3/4 of the way between the inner and outer arcs
  # sweep is dependent on quadrant
  sweep = Cfsjksas.Hybrid.Get.quadrant_sweep(sector.quadrant)
  # diff font sizes for names and date
  config = Cfsjksas.Hybrid.Get.config(gen)

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

  {beg_x_g, beg_y_g, end_x_g, end_y_g} = arc_ends(sector.quadrant, r_g, sector.lower_radians, sector.upper_radians)
  {beg_x_s, beg_y_s, end_x_s, end_y_s} = arc_ends(sector.quadrant, r_s, sector.lower_radians, sector.upper_radians)
  {beg_x_d, beg_y_d, end_x_d, end_y_d} = arc_ends(sector.quadrant, r_d, sector.lower_radians, sector.upper_radians)

  make_hidden_arc(id_g, r_g, beg_x_g, beg_y_g, end_x_g, end_y_g, sweep)
  <> make_name_text(id_g, font_size_n, gname)
  <> make_hidden_arc(id_s, r_s, beg_x_s, beg_y_s, end_x_s, end_y_s, sweep)
  <> make_name_text(id_s, font_size_n, sname)
  <> make_hidden_arc(id_d, r_d, beg_x_d, beg_y_d, end_x_d, end_y_d, sweep)
  <> make_name_text(id_d, font_size_d, dates)

end
def add_name(gen, person, sector) when gen in 7..14 do
  # one line of text along ray
  text = not_nil(person.given_name) <> " "
  <> not_nil(person.surname) <> " ("
  <> not_nil(person.birth_year) <> " - "
  <> not_nil(person.death_year) <> ")"

  # make hidden arcs to put text on
  id = "ray_g" <> to_string(gen) <> "_s" <> to_string(person.sector)

  # draw the arc 1/2 way between the inner and outer rays
  ## get config
  config = Cfsjksas.Hybrid.Get.config(gen)
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
  {inner_x, inner_y} = Cfsjksas.Hybrid.Get.xy(r_inner, phi)
  {outer_x, outer_y} = Cfsjksas.Hybrid.Get.xy(r_outer, phi)

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

defp arc_ends(quadrant, r, angle1, angle2)
    when quadrant in [:ne, :nw] do
  # arc begins at lower_radians and ends at upper_radians
  # so that words have right orientation
  {beg_x, beg_y} = Cfsjksas.Hybrid.Get.xy(r, angle1)
  {end_x, end_y} = Cfsjksas.Hybrid.Get.xy(r, angle2)
  {beg_x, beg_y, end_x, end_y}
end
defp arc_ends(quadrant, r, angle1, angle2)
    when quadrant in [:se, :sw] do
  # arc begins at upper_radians and ends at lower_radians
  # so that words have right orientation
  {beg_x, beg_y} = Cfsjksas.Hybrid.Get.xy(r, angle2)
  {end_x, end_y} = Cfsjksas.Hybrid.Get.xy(r, angle1)
  {beg_x, beg_y, end_x, end_y}
end
defp arc_ends(quadrant, r, angle1, angle2) do
  IO.inspect({quadrant, r, angle1, angle2}, label: "arc_ends bad input")
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

defp not_nil(input) when is_binary(input) do
  # is string so return as is
  input
end
defp not_nil(input) when is_nil(input) do
  # is empty so return blank space (maybe should return question mark?)
  " "
end



end
