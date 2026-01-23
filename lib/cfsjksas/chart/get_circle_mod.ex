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
      7 => 2500, 8 => 2000, 9 => 2400, 10 => 2300, 11 => 1500, 12 => 900,
      13 => 800, 14 => 650, 15 => 50, 16 => 50,
      -1 => 0,
      outer_ring: 21000,
      band: %{
      0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0,
      7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 75,
      13 => 75, 14 => 75,
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
        :links,
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
        font_size: "32pt",
        stroke_width: "10",
      },
      13 => %{
        layout: :ray1,
        font_size: "32pt",
        stroke_width: "10"
      },
      14 => %{
        layout: :ray1,
        font_size: "32pt",
        stroke_width: "10",
      },
    },
  }

  # config for rearranging outer generations with larger sectors
  @g11 %{
    12 => %{
      48 => 23, # p0219 Robert Stetson
      49 => 24, # p0220 Honor Tucker
      54 => 25, # p0221 Isaac Chittenden
      55 => 26, # p0238 Sarah Chittenden
      56 => 27,
      57 => 28,
      60 => 30, # Thomas Hatch
      61 => 31,
      62 => 32,
      112 => 56, # p0219 Robert Stetson
      113 => 57, # p0220 Honor Tucker
      118 => 59, # p0221 Isaac Chittenden
      119 => 60, # p0238 Sarah Chittenden
      124 => 62, # p0366 Thomas Hatch
      125 => 63, # p0365 Lydia Unknown074
      126 => 64, # p0362 John Hewes
      138 => 69, # p0381 Richard Gaymer
      140 => 70, #
      141 => 71, #
      252 => 125,
      253 => 126,
      254 => 127,
      255 => 128,
      410 => 205,
      411 => 206,
      472 => 236,
      473 => 237,
      476 => 239, # p9975, Gregory Stone
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
      1364 => 683, # p0509 William Brewster
      1365 => 684, #
      1398 => 699, # p0482 Richard Treat
      1399 => 700, #
      1406 => 703, #
      1407 => 704,
      1492 => 745,
      1493 => 746,
      1494 => 747,
      1495 => 748,
      1502 => 751,
      1503 => 752,
      1570 => 785, #
      1571 => 786, #
      1580 => 790, #
      1581 => 791, #
      1583 => 792, #
      1584 => 793, #
      1585 => 794, #
      1586 => 795, #
      1587 => 796, #
      1594 => 797, #
      1595 => 798, #
      1596 => 799, #
      1622 => 811, #
      1623 => 812, #
      1630 => 815, #
      1631 => 816, #
      1654 => 827, #
      1655 => 828, #
      1658 => 829, #
      1662 => 831, #
      1663 => 832, #
      1674 => 837, #
      1675 => 838, #
      1676 => 839, #
      1677 => 840, #
      1678 => 841, #
      1679 => 842, #
      1722 => 861, #
      1723 => 862, #
      1724 => 863, #
      1725 => 864, #
      1726 => 865, #
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
      3643 => 1822,
      3644 => 1823,
      3670 => 1835,
      3671 => 1836,
      3678 => 1839,
      3679 => 1840, # Lucrieta Oldham
      3702 => 1851,
      3703 => 1852,
      3706 => 1853,
      3710 => 1855,
      3711 => 1856,
      3836 => 1917,
      3837 => 1918,
#     3838 => 1919,
      3839 => 1919,
      3856 => 1928, # s3856 = p0356 = Robert Parke
      3857 => 1929, #
      3859 => 1930, #
      3866 => 1933,
      3876 => 1937,
      3877 => 1938,
      3878 => 1939,
      3879 => 1940,
      3904 => 1951,
      3905 => 1952,
      3906 => 1953,
      3914 => 1954,
      3915 => 1955,
      3916 => 1956,
      3917 => 1957,
      3918 => 1958, #parke
      3919 => 1959,
      3922 => 1960,
      3923 => 1961,
      3926 => 1962,
      3927 => 1963, # lockwood
      3932 => 1964,
      3933 => 1965,
      3934 => 1966,
    # 3935 => 1965,
      3936 => 1967,
      3937 => 1968,
      3938 => 1969,
      3939 => 1970,
    # 3940 => 1970,
    # 3941 => 1971,
      3944 => 1972,
      3945 => 1973,
      3948 => 1974,
      3949 => 1975,
      3950 => 1976,
      3951 => 1977,
      3952 => 1978,
      3953 => 1979,
      3954 => 1980,
      3955 => 1981, # Sarah Masterson
      3956 => 1982,
      3957 => 1983,
      3974 => 1987,
      3975 => 1988,
      3990 => 1995,
      3991 => 1996,
      4006 => 2003, # s4006 = p0487 = Jonathan Brewster
      4007 => 2004, # s4007
    },
    13 => %{
      2366 => 593, # 1183
      2367 => 594, # 1184
      6910 => 1728, # 3455
      6911 => 1729, # 3456
      7890 => 1972, # 3944
      7891 => 1973, # 3945
      7906 => 1979, # 3952
      7907 => 1980, # 3953
      7910 => 1981, # 3955
      7911 => 1982, # 3956
    },
    14 => %{
      15814 => 1980, # 3952
      15815 => 1981, # 3953
    }
  }

  @lines [
      # list of tuples for rays from g12 mid-inner-arc to g11 mid-outer-arc
      {{12,27},{11,28}},
      {{12,28},{11,28}},
      {{12,30},{11,30}},
      {{12,31},{11,30}},
      {{12,32},{11,31}},
      {{12,125},{11,126}},
      {{12,126},{11,126}},
      {{12,127},{11,127}},
      {{12,128},{11,127}},
      {{12,205},{11,205}},
      {{12,206},{11,205}},
      {{12,236},{11,236}},
      {{12,237},{11,236}},
      {{12,239},{11,238}}, # Gregory Stone p9975
      {{12,566},{11,566}},
      {{12,567},{11,567}},
      {{12,568},{11,567}},
      {{12,585},{11,586}},
      {{12,586},{11,586}},
      {{12,587},{11,587}},
      {{12,588},{11,587}},
      {{12,590},{11,590}},
      {{12,591},{11,590}},
      {{12,592},{11,591}},
      {{12,593},{11,591}},
      {{12,680},{11,680}},
      {{12,681},{11,680}},
      {{12,745},{11,746}},
      {{12,746},{11,746}},
      {{12,747},{11,747}},
      {{12,748},{11,747}},
      {{12,751},{11,751}},
      {{12,752},{11,751}},
      {{12,1727},{11,1727}},
      {{12,1728},{11,1727}},
      {{12,1809},{11,1809}},
      {{12,1810},{11,1809}},
      {{12,1813},{11,1814}},
      {{12,1814},{11,1814}},
      {{12,1815},{11,1815}},
      {{12,1816},{11,1815}},
      {{12,1817},{11,1816}},
      {{12,1818},{11,1816}},
      {{12,1819},{11,1817}},
      {{12,1820},{11,1817}},
      {{12,1821},{11,1821}},
      {{12,1822},{11,1821}},
      {{12,1823},{11,1822}},
      {{12,1835},{11,1835}},
      {{12,1836},{11,1835}},
      {{12,1839},{11,1839}},
      {{12,1840},{11,1839}}, # Lucrieta Oldham
      {{12,1851},{11,1851}},
      {{12,1852},{11,1851}},
      {{12,1853},{11,1853}},
      {{12,1855},{11,1855}},
      {{12,1856},{11,1855}},
      {{12,1917},{11,1918}},
      {{12,1918},{11,1918}},
      {{12,1919},{11,1919}},
    #  {{12,1920},{11,1919}},
      {{12,1933},{11,1933}},
      {{12,1937},{11,1938}},
      {{12,1938},{11,1938}},
      {{12,1939},{11,1939}},
      {{12,1940},{11,1939}},
      {{12,1951},{11,1952}},
      {{12,1952},{11,1952}},
      {{12,1953},{11,1953}},
      {{12,1954},{11,1957}},
      {{12,1955},{11,1957}},
      {{12,1956},{11,1958}},
      {{12,1957},{11,1958}},
      {{12,1958},{11,1959}},
      {{12,1959},{11,1959}},
      {{12,1960},{11,1961}},
      {{12,1961},{11,1961}},
      {{12,1962},{11,1963}},
      {{12,1963},{11,1963}},
#      {{12,1964},{11,1966}}, # Freeman
#      {{12,1965},{11,1966}}, # Freeman
      {{12,1966},{11,1967}}, # Noyes
#      {{12,1965},{11,1966}},
      {{12,1967},{11,1968}},
      {{12,1968},{11,1968}},
      {{12,1969},{11,1969}},
      {{12,1970},{11,1969}}, # Elizabeth unknownCooke
#      {{12,1970},{11,1970}},
#      {{12,1971},{11,1970}},
      {{12,1972},{11,1972}}, # William Fellows
      {{12,1973},{11,1972}},
      {{12,1974},{11,1974}},
      {{12,1975},{11,1974}},
      {{12,1976},{11,1975}},
      {{12,1977},{11,1975}},
      {{12,1978},{11,1976}},
      {{12,1979},{11,1976}},
      {{12,1980},{11,1977}},
      {{12,1981},{11,1977}}, # Sarah Masterson
#      {{12,1982},{11,1978}},
#      {{12,1983},{11,1978}},
      {{12,1987},{11,1987}},
      {{12,1988},{11,1987}}, # lucretia Oldham
      {{12,1995},{11,1995}},
      {{12,1996},{11,1995}},
      {{13,593},{12,593}},
      {{13,594},{12,593}},
      {{13,1728},{12,1728}},
      {{13,1729},{12,1728}},
      {{13,1972},{12,1973}},
      {{13,1973},{12,1973}},
      {{13,1979},{12,1979}},
      {{13,1980},{12,1979}},
      {{13,1981},{12,1981}},
      {{13,1982},{12,1981}},
      {{14,1980},{13,1980}},
      {{14,1981},{13,1980}},
    ]

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

  def touchup_list() do
    @lines
  end

  def other() do
    @config.already.other
  end

  def vitals() do
    @config.already.vitals
  end

  def links() do
    @config.already.links
  end

  def dontcare() do
    # person keys already covered or don't care about
    @config.already.dontcare
  end

  def already() do
    other() ++ vitals() ++ links() ++ dontcare()
  end


end
