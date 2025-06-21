defmodule Cfsjksas.Hybrid.Get do

  require IEx

  @mxc 14000  # center of page/circle
  @myc 21000  # center of page/circle
  @width "\"48in\""
  @height "\"59in\""
  @viewbox_low_x 0
  @viewbox_hi_x 34000
  @viewbox_low_y 0
  @viewbox_hi_y 42000
  @radii %{ 0 => 2000, 1 =>600, 2 =>600, 3 => 1000, 4 => 1000, 5 => 1000, 6 => 500,
            7 => 2500, 8 => 2000, 9 => 2400, 10 => 2300, 11 => 1500, 12 => 700,
            13 => 600, 14 => 600, 15 => 50, 16 => 50, -1 => 0 }
  @outer_ring_radius 21000
  @ancestors_svg "static/images/ancestors.svg"

  @config %{
    0 => %{
      font_size1: "150pt",
      font_size2: "120pt",
      stroke_width: "50",
      name1: "Charles Fisher Sparrell",
      date1: "(1928 - 2007)",
      name2: "James Kirkwood Sparrell",
      date2: "(1932 - 2015)",
      name3: "Ann Sparrell",
      date3: "(1933 - 2023)"
    },
    1 => %{
      font_size: "150pt",
      stroke_width: "80",
    },
    2 => %{
      font_size: "150pt",
      stroke_width: "80",
    },
    3 => %{
      font_size_n: "150pt",
      font_size_d: "100pt",
      stroke_width: "80",
    },
    4 => %{
      font_size_n: "125pt",
      font_size_d: "100pt",
      stroke_width: "80",
    },
    5 => %{
      font_size_n: "90pt",
      font_size_d: "75pt",
      stroke_width: "80",
    },
    6 => %{
      font_size_n: "75pt",
      font_size_d: "50pt",
      stroke_width: "80",
    },
    7 => %{
      font_size: "90pt",
      stroke_width: "70",
    },
    8 => %{
      font_size: "75pt",
      stroke_width: "50",
    },
    9 => %{
      font_size: "75pt",
      stroke_width: "20",
    },
    10 => %{
      font_size: "50pt",
      stroke_width: "15",
    },
    11 => %{
      font_size: "32pt",
      stroke_width: "10",
    },
    12 => %{
      font_size: "24pt",
      stroke_width: "5",
    },
    13 => %{
      font_size: "24pt",
      stroke_width: "5"
    },
    14 => %{
      font_size: "24pt",
      stroke_width: "5",
    },
  }

  # for redoing G13 as G12 size sectors
  @hybrid13 %{
    2366 => 1183,
    2367 => 1184,
    6910 => 3455,
    6911 => 3456,
    7890 => 3944,
    7891 => 3945,
    7906 => 3952,
    7907 => 3953,
    7910 => 3955,
    7911 => 3956,
  }

  @hybrid14 %{
    15814 => 3952,
    15815 => 3953
  }

  # draw line from g12 to g13 special sectors
  @xtra_lines13 [{1183, 1183},
                {1183, 1184},
                {3455, 3455},
                {3455, 3456},
                {3953, 3952},
                {3953, 3953},
                {3955, 3955},
                {3955, 3956},
                {3944, 3944},
                {3944, 3945},
  ]

  # draw line from g13 to g14 special sectors
  @xtra_lines14 [{3952, 3952}, {3952, 3953}]

  @other [
			:census,
			:description,
			:education,
			:emigration,
			:event,
			:former_name,
			:graduation,
			:immigration,
			:name_prefix,
			:name_suffix,
			:naturalized,
			:nickname,
			:notes,
			:occupation,
			:ordained,
			:probate,
			:religion,
			:residence,
			:title,
			:will,
  ]


  def path(:ancestors_svg) do
    Path.join(:code.priv_dir(:cfsjksas), @ancestors_svg)
  end

  def center() do
    {@mxc, @myc}
  end

  def radius(:outer_ring) do
    @outer_ring_radius
  end
  def radius(-1) do
    @radii[-1]
  end
  def radius(0) do
    @radii[0]
  end
  def radius(n) do
    @radii[n] + radius(n-1)
  end

  def config(gen) do
    @config[gen]
  end

  def xy(radius, radians) do
    x = @mxc + ( Complex.from_polar(radius, radians) |> Complex.real() |> round() )
    # recall y is positive is down not up in svg
    y = @myc - ( Complex.from_polar(radius, radians) |> Complex.imag() |> round() )
    {x,y}
  end

    @doc """
  given quadrant, find sweep
  """
  def quadrant_sweep(:ne) do
    "1"
  end
  def quadrant_sweep(:nw) do
    "1"
  end
  def quadrant_sweep(:sw) do
    "0"
  end
  def quadrant_sweep(:se) do
    "0"
  end

  @doc """
  input: termination type
  output: {fill, fill_opacity}
  """
  def fill(termination) do
    case termination do
      :normal ->
        # not termination
        {"none", "0%"}
      :ship ->
        {"dodgerblue", "10%"}
      :no_ship ->
        {"lightskyblue", "10%"}
      :duplicate ->
        {"lightgreen", "50%"}
      :brickwall_both ->
        {"red", "50%"}
      :brickwall_mother ->
        {"red", "30%"}
      :brickwall_father ->
        {"red", "30%"}
      _ ->
        IEx.pry()
    end
  end

  @doc """
  determine line color based on whether person is a father or mother
  """
  def line_color(this_relation) do
    case Enum.take(this_relation, -1) do
      ["M"] ->
        "#FF6EC7"
      ["P"] ->
        "blue"
      _ ->
        IEx.pry()
    end
  end

  @doc """
  return viewbox as ascii string
  constants set up above
  """
  def viewbox() do
     "viewBox=\""
    <> to_string(@viewbox_low_x)
    <> " "
    <> to_string(@viewbox_low_y)
    <> " "
    <> to_string(@viewbox_hi_x)
    <> " "
    <> to_string(@viewbox_hi_y)
    <> "\""
  end

  def size() do
    "width="
    <> @width
    <> " height="
    <> @height
    <> " "
  end

  def hybrid_g13(sector) do
    # for special case of gen 13 return:
    # {inner_radius, outer_radius, lower_radians, upper_radians}
    # get location thru customer lookup
    inner_radius = radius(12) + 100
    outer_radius = radius(13)
    # fix
    new_sector_num = @hybrid13[sector.sector_num]
    lower_radians = new_sector_num * 2 * :math.pi() / (2 ** 12)
    upper_radians = rem(new_sector_num + 1, 2**12) * 2 * :math.pi() / (2 ** 12)
    {inner_radius, outer_radius, lower_radians, upper_radians}
  end
  def hybrid_g14(sector) do
    # for special case of gen 14 return:
    # {inner_radius, outer_radius, lower_radians, upper_radians}
    # get location thru customer lookup
    inner_radius = radius(13) + 100
    outer_radius = radius(14)
    # fix
    new_sector_num = @hybrid14[sector.sector_num]
    lower_radians = new_sector_num * 2 * :math.pi() / (2 ** 12)
    upper_radians = rem(new_sector_num + 1, 2**12) * 2 * :math.pi() / (2 ** 12)
    {inner_radius, outer_radius, lower_radians, upper_radians}
  end

  def xtra_lines(13) do
    @xtra_lines13
  end

  def xtra_lines(14) do
    @xtra_lines14
  end

  def other() do
    @other
  end






end
