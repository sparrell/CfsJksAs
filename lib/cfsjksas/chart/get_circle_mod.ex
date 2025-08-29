defmodule Cfsjksas.Chart.GetCircleMod do

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
      band: %{
      0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0,
      7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 100,
      13 => 100, 14 => 100,
      }
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
    12 => %{
      56 => 27,
      57 => 28,
      60 => 30,
      61 => 31,
      62 => 32,
      210 => 105,
      211 => 106,
      252 => 125,
      253 => 126,
      254 => 127,
      255 => 128,
      388 => 194,
      389 => 195,
      402 => 201,
      403 => 202,
      410 => 205,
      411 => 206,
      472 => 236,
      473 => 237,
      1082 => 541,
      1083 => 542,
      1102 => 551,
      1103 => 552,
      1132 => 566,
      1134 => 567,
      1135 => 568,
      1172 => 585,
      1173 => 586,
      1174 => 587,
      1175 => 588,
      1180 => 590,
      1181 => 591,
      1182 => 592,
      1183 => 593,
      1360 => 680,
      1361 => 681,
      1492 => 745,
      1493 => 746,
      1494 => 747,
      1495 => 748,
      1502 => 751,
      1503 => 752,
      3454 => 1727,
      3455 => 1728,
      3618 => 1809,
      3619 => 1810,
      3628 => 1813,
      3629 => 1814,
      3630 => 1815,
      3631 => 1816,
      3632 => 1817,
      3633 => 1818,
      3634 => 1819,
      3635 => 1820,
      3642 => 1821,
      3643 => 1821,
      3644 => 1822,
      3670 => 1835,
      3671 => 1836,
      3678 => 1839,
      3679 => 1840,
      3700 => 1850,
      3702 => 1851,
      3703 => 1852,
      3706 => 1853,
      3710 => 1855,
      3711 => 1856,
      3752 => 1875,
      3753 => 1876,
      3756 => 1878,
      3757 => 1879,
      3758 => 1880,
      3759 => 1881,
      3836 => 1918,
      3837 => 1919,
      3838 => 1920,
      3839 => 1921,
      3866 => 1933,
      3876 => 1937,
      3877 => 1938,
      3878 => 1939,
      3879 => 1940,
      3904 => 1951,
      3905 => 1952,
      3906 => 1953,
      3914 => 1957,
      3915 => 1958,
      3916 => 1959,
      3917 => 1960,
      3918 => 1961,
      3919 => 1962,
      3922 => 1963,
      3923 => 1964,
      3926 => 1965,
      3927 => 1966,
      3932 => 1967,
      3933 => 1968,
      3936 => 1969,
      3937 => 1970,
      3938 => 1971,
      3939 => 1972,
      3940 => 1973,
      3941 => 1974,
      3944 => 1975,
      3945 => 1976,
      3946 => 1977,
      3947 => 1978,
      3948 => 1979,
      3949 => 1980,
      3950 => 1981,
      3951 => 1982,
      3952 => 1983,
      3953 => 1984,
      3954 => 1985,
      3955 => 1986,
      3956 => 1987,
      3957 => 1988,
      3974 => 1989,
      3975 => 1990,
      3990 => 1995,
      3991 => 1996,
      4070 => 2035,
      4071 => 2036,
      4078 => 2039,
      4079 => 2040,
    },
    13 => %{
      2350 => 587,
      2351 => 588,
      2366 => 593, # 1183
      2367 => 594, # 1184
      6910 => 1728, # 3455
      6911 => 1729, # 3456
      7400 => 1850,
      7401 => 1851,
      7754 => 1938,
      7755 => 1939,
      7756 => 1940,
      7757 => 1941,
      7758 => 1942,
      7759 => 1943,
      7830 => 1957,
      7831 => 1958,
      7846 => 1961,
      7847 => 1962,
      7854 => 1963,
      7855 => 1964,
      7874 => 1968,
      7875 => 1969,
      7890 => 1972, # 3944
      7891 => 1973, # 3945
      7906 => 1984, # 3952
      7907 => 1985, # 3953
      7910 => 1986, # 3955
      7911 => 1987, # 3956
    },
    14 => %{
      15814 => 1985, # 3952
      15815 => 1986, # 3953
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
    outer_radius(gen - 1) + @config.radii.band[gen]
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

  def g11(gen, sector) do
    @g11[gen][sector]
  end

end
