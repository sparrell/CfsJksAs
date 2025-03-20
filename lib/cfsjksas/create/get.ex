defmodule Cfsjksas.Create.Get do
  # constants and config variables

  # viewbox
  @mxc 21000  # center of page
  @myc 21000  # center of page

  @config %{
    0 => %{
      radius: 400,
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
      name_type: :one_arc,
      font_sizes: ["30pt", "15pt"],
      stroke_width: "20",
    },
    2 => %{
      radius: 150,
      name_type: :one_arc,
      font_sizes: ["25pt", "15pt"],
      stroke_width: "20",
    },
    3 => %{
      radius: 150,
      name_type: :two_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    4 => %{
      radius: 150,
      name_type: :three_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    5 => %{
      radius: 150,
      name_type: :three_arcs,
      font_sizes: ["20pt", "15pt"],
      stroke_width: "20",
    },
    6 => %{
      radius: 150,
      name_type: :three_arcs,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "10",
    },
    7 => %{
      radius: 200,
      name_type: :two_rays,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    8 => %{
      radius: 280,
      name_type: :one_ray,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    9 => %{
      radius: 280,
      name_type: :one_ray,
      font_sizes: ["10pt", "10pt"],
      stroke_width: "5",
    },
    10 => %{
      radius: 250,
      name_type: :one_ray,
      font_sizes: ["8pt", "8pt"],
      stroke_width: "4",
    },
  }

  def radius(-1) do
    @config[-1].radius
  end
  def radius(0) do
    @config[0].radius
  end
  def radius(gen) do
    @config[gen].radius + radius(gen - 1)
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
