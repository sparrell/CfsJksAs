defmodule Cfsjksas.Hybrid.Get do

  require IEx

  @mxc 21000  # center of page/circle
  @myc 21000  # center of page/circle
  @viewbox_low_x 7000
  @viewbox_hi_x 42000
  @viewbox_low_y 0
  @viewbox_hi_y 42000
  @radii %{ 0 => 2000, 1 =>600, 2 =>600, 3 => 1000, 4 => 1000, 5 => 1000, 6 => 500,
            7 => 2500, 8 => 2000, 9 => 2400, 10 => 2300, 11 => 1500, 12 => 1200,
            13 => 1200, 14 => 300, 15 => 50, 16 => 50, -1 => 0 }
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
      font_size_n: "150pt",
      font_size_d: "100pt",
      stroke_width: "80",
    },
    5 => %{
      font_size_n: "100pt",
      font_size_d: "100pt",
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
      font_size: "16pt",
      stroke_width: "5",
    },
    13 => %{
      font_size: "10pt",
      stroke_width: "2",
    },
    14 => %{
      font_size: "6pt",
      stroke_width: "1",
    },
  }

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
  "\""
  <> to_string(@viewbox_low_x)
  <> " "
  <> to_string(@viewbox_low_y)
  <> " "
  <> to_string(@viewbox_hi_x)
  <> " "
  <> to_string(@viewbox_hi_y)
  <> "\""
  end

  def hybrid_g13() do
    # return {inner_radius, outer_radius} for special case of gen 13
    {radius(12), radius(13)}
  end


end
