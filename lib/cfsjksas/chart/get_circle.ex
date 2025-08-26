defmodule Cfsjksas.Chart.GetCircle do

  @width  "\"48in\""
  @height "\"59in\""
  @viewbox_low_x 0
  @viewbox_hi_x 34000
  @viewbox_low_y 0
  @viewbox_hi_y 42000


  @config %{
    primary: :p0005,
    svg: %{
      mxc: 14000,  # center of page/circle
      myc: 21000,  # center of page/circle
      width: @width,
      height: @height,
      size: "width=" <> @width <> " height=" <> @height <> " ",
      viewbox_low_x: @viewbox_low_x,
      viewbox_hi_x: @viewbox_hi_x,
      viewbox_low_y: @viewbox_low_y,
      viewbox_hi_y: @viewbox_hi_y,
      viewbox: "viewBox=\""
        <> to_string(@viewbox_low_x) <> " "
        <> to_string(@viewbox_low_y) <> " "
        <> to_string(@viewbox_hi_x) <> " "
        <> to_string(@viewbox_hi_y) <> "\"",
    },
    radii: %{
      0 => 2000, 1 => 600, 2 => 600, 3 => 1000, 4 => 1000, 5 => 1000, 6 => 500,
      7 => 2500, 8 => 2000, 9 => 2400, 10 => 2300, 11 => 1500, 12 => 700,
      13 => 600, 14 => 600, 15 => 50, 16 => 50,
      -1 => 0,
      outer_ring: 21000,
    },
    already: %{
      other: [
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
      ],
      vitals: [
        :sex,
        :married_name,
        :given_name,
        :also_known_as,
        :birth_date,
        :birth_place,
        :birth_note,
        :birth_source,
        :birth_year,
        :baptism,
        :christening,
        :death_date,
        :death_place,
        :death_note,
        :death_year,
        :buried,
        :death_age,
        :death_cause,
        :death_source,
      ],
      links: [
        :geni,
        :werelate,
        :myheritage,
        :wikipedia,
        :wikitree,
      ],
      dontcare: [
        :ship,
        :no_ship,
        :uid,
        :mh_famc,
        :mh_fams,
        :family_of_procreation,
        :family_of_origin,
        :relation_list,
        :mh_id,
        :mh_famc2,
        :rin,
        :sources,
        :upd,
        :surname,
        :mh_name,
        :id,
        :father,
        :mother,
      ],
    },
    sector: %{
      0 => %{
        layout: :circle,
        font_size1: "150pt",
        font_size2: "120pt",
        stroke_width: "50",
        name1: "Charles Fisher Sparrell",
        date1: "(1928 - 2007)",
        name2: "James Kirkwood Sparrell",
        date2: "(1932 - 2015)",
        name3: "Ann Sparrell",
        date3: "(1933 - 2023)",
        line_color: "black",
        fill: "none",
        fill_opacity: "50%"
      },
      1 => %{
        layout: :arc1,
        font_size: "150pt",
        stroke_width: "80",
      },
      2 => %{
        layout: :arc1,
        font_size: "150pt",
        stroke_width: "80",
      },
      3 => %{
        layout: :arc2,
        font_size_n: "150pt",
        font_size_d: "100pt",
        stroke_width: "80",
      },
      4 => %{
        layout: :arc3,
        font_size_n: "125pt",
        font_size_d: "100pt",
        stroke_width: "80",
      },
      5 => %{
        layout: :arc3,
        font_size_n: "90pt",
        font_size_d: "75pt",
        stroke_width: "80",
      },
      6 => %{
        layout: :arc3,
        font_size_n: "75pt",
        font_size_d: "50pt",
        stroke_width: "80",
      },
      7 => %{
        layout: :ray1,
        font_size: "90pt",
        stroke_width: "70",
      },
      8 => %{
        layout: :ray1,
        font_size: "75pt",
        stroke_width: "50",
      },
      9 => %{
        layout: :ray1,
        font_size: "75pt",
        stroke_width: "20",
      },
      10 => %{
        layout: :ray1,
        font_size: "50pt",
        stroke_width: "15",
      },
      11 => %{
        layout: :ray1,
        font_size: "32pt",
        stroke_width: "10",
      },
      12 => %{
        layout: :ray1,
        font_size: "24pt",
        stroke_width: "5",
      },
      13 => %{
        layout: :ray1,
        font_size: "24pt",
        stroke_width: "5"
      },
      14 => %{
        layout: :ray1,
        font_size: "24pt",
        stroke_width: "5",
      },
    },
  }

  @g11 %{
    14 => %{
      15814 => 1976, # 3952
      15815 => 1977, # 3953
    }
  }

  def config() do
    @config
  end

  def path(filename) do
    Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)
  end

  def radius(-1) do
    @config.radii[-1]
  end
  def radius(0) do
    @config.radii[0]
  end
  def radius(n) do
    @config.radii[n] + radius(n-1)
  end

  def inner_radius(0) do
    0
  end
  def inner_radius(gen) do
    outer_radius(gen - 1)
  end

  def outer_radius(0) do
    0
  end
  def outer_radius(gen) do
    inner_radius(gen) + @config.radii[gen]
  end

  def xy(radius, radians) do
    x = @config.svg.mxc + ( Complex.from_polar(radius, radians) |> Complex.real() |> round() )
    # recall y is positive is down not up in svg
    y = @config.svg.myc - ( Complex.from_polar(radius, radians) |> Complex.imag() |> round() )
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
