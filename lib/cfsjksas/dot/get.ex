defmodule Cfsjksas.Dot.Get do
  @moduledoc """
  routines for constants in graphviz twopi for each generation
  """
  @ancestors_dot "static/images/ancestors.dot"
  @ancestors_dot_svg "static/images/ancestors_dot.svg"

  @config %{
    0 => %{
      font_size: "100",
      name1: "Charles Fisher Sparrell",
      date1: "(1928 - 2007)",
      name2: "James Kirkwood Sparrell",
      date2: "(1932 - 2015)",
      name3: "Ann Sparrell",
      date3: "(1933 - 2023)"
    },
    1 => %{
      font_size: "100",
    },
    2 => %{
      font_size: "100",
    },
    3 => %{
      font_size: "100",
    },
    4 => %{
      font_size: "100",
    },
    5 => %{
      font_size: "100",
    },
    6 => %{
      font_size: "75",
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

  def path(:ancestors_dot) do
    Path.join(:code.priv_dir(:cfsjksas), @ancestors_dot)
  end
  def path(:ancestors_dot_svg) do
    Path.join(:code.priv_dir(:cfsjksas), @ancestors_dot_svg)
  end

  def config(gen) do
    @config[gen]
  end

end
