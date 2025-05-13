defmodule Cfsjksas.Create.Get do
  # constants and config variables

  # viewbox
  @mxc 21000  # center of page
  @myc 21000  # center of page

  @config %{
    0 => %{
      radius: 400,
      number_bands: 1,
      name_type: :circle,
      font_sizes: ["30pt", "20pt"],
      stroke_width: "20",
      name1: "Charles Fisher Sparrell",
      date1: "(1928 - 2007)",
      name2: "James Kirkwood Sparrell",
      date2: "(1932 - 2015)",
      name3: "Ann Sparrell",
      date3: "(1933 - 2023)",
    },
    1 => %{
      radius: 150,
      number_bands: 1,
      name_type: :one_arc,
      font_sizes: ["30pt", "15pt"],
      stroke_width: "20",
    },
    2 => %{
      radius: 150,
      number_bands: 1,
      name_type: :one_arc,
      font_sizes: ["25pt", "15pt"],
      stroke_width: "20",
    },
    3 => %{
      radius: 150,
      number_bands: 1,
      name_type: :two_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    4 => %{
      radius: 150,
      number_bands: 1,
      name_type: :three_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    5 => %{
      radius: 150,
      number_bands: 1,
      name_type: :three_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    6 => %{
      radius: 150,
      number_bands: 1,
      name_type: :three_arcs,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "10",
    },
    7 => %{
      radius: 200,
      number_bands: 1,
      name_type: :two_rays,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    8 => %{
      radius: 280,
      number_bands: 1,
      name_type: :one_ray,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    9 => %{
      radius: 280,
      number_bands: 1,
      name_type: :one_ray,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    10 => %{
      radius: 250,
      number_bands: 1,
      name_type: :one_ray,
      font_sizes: ["8pt", "8pt"],
      stroke_width: "4",
    },
    11 => %{
      radius: 500,
      number_bands: 2,
      bands: [250, 250],
      name_type: :one_ray,
      font_sizes: ["8pt", "8pt"],
      stroke_width: "4",
    },
  }

  @annuli %{
    0 => 400,
    1 => 150,
    2 => 150,
    3 => 150,
    4 => 150,
    5 => 150,
    6 => 150,
    7 => 200,
    8 => 280,
    9 => 280,
    10 => 250,
    11 => 250,
    12 => 250,
    13 => 250,
    14 => 250,
    15 => 250,
    16 => 250,
    17 => 250,
  }

  def radius(0) do
    @config[0].radius
  end
  def radius(gen) do
    @config[gen].radius + radius(gen - 1)
  end

  def annulus(0) do
    {0, @annuli[0]}
  end
  def annulus(n) do
    {_prev_inner, prev_outer} = annulus(n-1)
    {prev_outer, prev_outer + @annuli[n]}
  end

  def gen_bands(0) do
    @config[0].number_bands - 1
  end
  def gen_bands(gen) do
    gen_bands(gen-1) + @config[gen].number_bands
  end

  def gen_to_bands(0) do
    # gen zero special case since no gen beneath it
    upper_band = gen_bands(0)
    lower_band = 0
    Enum.to_list(lower_band..upper_band)
  end
  def gen_to_bands(gen) do
    upper_band = gen_bands(gen)
    lower_band = gen_bands(gen-1) + 1
    Enum.to_list(lower_band..upper_band)
  end

  def center() do
    {@mxc, @myc}
  end

  def viewbox() do
    {2 * @mxc, 2 * @myc}
  end

  @doc """
  return confing for that generation
  """
  def config(gen) do
    @config[gen]
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


end
