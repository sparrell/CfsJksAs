defmodule Cfsjksas.Dot.Get do
  @moduledoc """
  routines for constants in graphviz twopi for each generation
  """
  @ancestors_dot "static/images/ancestors.dot"
  @ancestors_dot_svg "static/images/ancestors_dot.svg"

  @config %{
    0 => %{
      font_size: "8",
      name1: "Charles Fisher Sparrell",
      date1: "(1928 - 2007)",
      name2: "James Kirkwood Sparrell",
      date2: "(1932 - 2015)",
      name3: "Ann Sparrell",
      date3: "(1933 - 2023)"
    },
    1 => %{
      font_size: "8",
    },
    2 => %{
      font_size: "8",
    },
    3 => %{
      font_size: "8",
    },
    4 => %{
      font_size: "8",
    },
    5 => %{
      font_size: "8",
    },
    6 => %{
      font_size: "8",
    },
    7 => %{
      font_size: "8",
    },
    8 => %{
      font_size: "8",
    },
    9 => %{
      font_size: "8",
    },
    10 => %{
      font_size: "8",
    },
    11 => %{
      font_size: "8",
    },
    12 => %{
      font_size: "8",
    },
    13 => %{
      font_size: "8",
    },
    14 => %{
      font_size: "8",
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
