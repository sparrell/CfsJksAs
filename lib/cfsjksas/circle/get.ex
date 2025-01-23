defmodule Cfsjksas.Circle.Get do
  @mxc 21000  # center of page
  @myc 21000  # center of page
  @radii %{ 0 => 2000, 1 =>600, 2 =>600, 3 => 1000, 4 => 1000, 5 => 1000, 6 => 1000,
            7 => 2500, 8 => 2000, 9 => 2400, 10 => 2300, 11 => 1500, 12 => 1200,
            13 => 1200, 14 => 300, 15 => 50, 16 => 50, -1 => 0 }
  @ancestors_relations "./priv/static/gendata/ancestors_relations.g.ex.txt"
  @ancestors_ids "./priv/static/gendata/ancestors_ids.g.ex.txt"
  @ancestors_svg "./priv/static/images/ancestors.svg"

  @config %{
    0 => %{
      font_size1: "180pt",
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

  def path(:ancestors_relations) do
    @ancestors_relations
  end
  def path(:ancestors_ids) do
    @ancestors_ids
  end
  def path(:ancestors_svg) do
    @ancestors_svg
  end

  def center() do
    {@mxc, @myc}
  end

  def viewbox() do
    {2 * @mxc, 2 * @myc}
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


end
