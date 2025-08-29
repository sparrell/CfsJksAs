defmodule Cfsjksas.Chart.Sector do
  @moduledoc """
  Sector is main Struct of this module

  Each "sector" is shape for a person.
    A generation has 2**gen sectors, numbered from the x-axis.
    A sector is identified by the generation and the sector number.
    A sector is a closed shape which consists of 4 joined paths:
    - inner arc
    - outer arc
    - lower ray
    - upper ray
    These are defined by 4 points.
      A-------------------B
        *                *
         *              *
          *            *
           C----------D

    Point A:
      - 'higher' end on 'outer arc'
      - 'outside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point B:
      - 'lower' end on 'outer arc'
      - 'outside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Point C:
      - 'higher' end on 'inner arc'
      - 'inside' end of 'higher' ray
      - radians = (sector number + 1 mod gen**2) * 2pi / 2**gen
      - A and C have same radians
    Point D:
      - 'lower' end on 'inner arc'
      - 'inside' end of 'lower' ray
      - radians = (sector number) * 2pi / 2**gen
      - B and D have same radians
    Arc AB is the outer_arc
    Arc CD is the inner_arc
    Ray CA is the higher_ray
    Ray DB is the lower_ray

  make(generation, quadrant, sector_number)
     creates and populates the struct

  """
  require IEx

  defstruct [
    id: "need",
    gen: 0,
    sector_num: 0,
    gen11_sector_num: 0,
    layout: :ray1,
    given_name: "?",
    surname: "?",
    birth_year: "?",
    death_year: "?",
    line_color: "black",
    stroke_width: "50",
    fill: "none",
    fill_opacity: "50%",
    quadrant: :ne,
    reverse: false,
    inner_radius: 100,
    outer_radius: 200,
    lower_radians: 0,
    upper_radians: :math.pi(),
    a_x: 0,
    a_y: 0,
    b_x: 0,
    b_y: 0,
    c_x: 0,
    c_y: 0,
    d_x: 0,
    d_y: 0,
    svg: "",
    namelines: %{}
  ]

  @type t() :: %__MODULE__{
    id: String.t(),
    gen: integer(),
    sector_num: integer(),
    gen11_sector_num: integer(),
    layout: atom(),
    given_name: String.t(),
    surname: String.t(),
    birth_year: String.t(),
    death_year: String.t(),
    line_color: String.t(),
    stroke_width: String.t(),
    fill: String.t(),
    fill_opacity: String.t(),
    quadrant: atom(),
    reverse: boolean(),
    inner_radius: integer(),
    outer_radius: integer(),
    lower_radians: integer(),
    upper_radians: float(),
    a_x: integer(),
    a_y: integer(),
    b_x: integer(),
    b_y: integer(),
    c_x: integer(),
    c_y: integer(),
    d_x: integer(),
    d_y: integer(),
    svg: String.t(),
    namelines: map()
  }

  def make(id_l, person_l, person_a, cfg, chart_type) do
    {gen, quadrant, sector_number} = id_l
    # special case for brickwalls
    person_a = case person_a == nil do
      false ->
        person_a
      true ->
        %{
          given_name: "brickwall",
          surname: "",
          birth_year: "?",
          death_year: "?",
        }
    end

    new_struct(gen, quadrant, sector_number, cfg, person_l, person_a)
    |> add_g11_sector_number(chart_type)
    |> add_inner_radius(chart_type)
    |> add_outer_radius(chart_type)
    |> add_lower_radians(chart_type)
    |> add_upper_radians(chart_type)
    |> add_points(chart_type)

  end

  defp new_struct(gen, quad, sector_num, cfg, person_l, person_a) do
    # create some helper info before creating struct
    # id
    id = "sector_" <> to_string(gen) <> "_" <> to_string(sector_num)
    # layout
    layout = cfg.layout
    # reverse
    reverse = quadrant_reverse(quad)
    # line size is from config
    stroke_width = cfg.stroke_width
    # line color is function of male or female
    line_color = line_color(person_l.relation)
    # fill/fill_opacity is function of immigrant, duplicate, brickwall
    {fill, opacity} = format(person_l)
    # for name
    given_name = person_a.given_name
    surname = person_a.surname
    birth_year = person_a.birth_year
    death_year = person_a.death_year

    # return initialized struct
    %Cfsjksas.Chart.Sector{
      gen: gen,
      quadrant: quad,
      sector_num: sector_num,
      id: id,
      given_name: given_name,
      surname: surname,
      birth_year: birth_year,
      death_year: death_year,
      layout: layout,
      reverse: reverse,
      stroke_width: stroke_width,
      line_color: line_color,
      fill: fill,
      fill_opacity: opacity,
    }
  end

  defp add_g11_sector_number(%{gen: gen} = sector, :circle_mod_chart)
      when gen in [12, 13, 14] do
    # adjust placement for sectors in generations above 11
    ## using 11 size sectors
    ## lookup using get
    gen11_sector_num = Cfsjksas.Chart.GetCircleMod.g11(sector.gen, sector.sector_num)
    if gen11_sector_num == nil do
      IO.inspect({sector.gen, sector.sector_num}, label: "gen, sec_num")
      IEx.pry() # oops need to enter this data
    end

debug = "gen = #{gen}, "
<> "old sector = #{sector.sector_num}, "
<> "new sector = #{gen11_sector_num},"
<> "name = #{sector.given_name} #{sector.surname}"
IO.inspect(debug)

    %{sector | gen11_sector_num: gen11_sector_num}
  end
  defp add_g11_sector_number(sector, _chart_type) do
    # leave unchanged
    ## for all sectors in circle
    ## for sectors 11 and under in circle_mod
    sector
  end
  defp format(%{duplicate: :branch} = _person_l) do
    # if duplicate-branch, color green
    {"lightgreen", "50%"}
  end
  defp format(%{duplicate: :redundant} = _person_l) do
    # if duplicate-branch, color green
    {"lightgreen", "50%"}
  end
  defp format(%{immigrant: :ship} = _person_l) do
    # if ship, fill is blue
    {"dodgerblue", "10%"}
  end
  defp format(%{immigrant: :no_ship} = _person_l) do
    # if ship, fill is light blue
    {"lightskyblue", "10%"}
  end
  defp format(%{brickwall: true} = _person_l) do
    # if duplicate-branch, color green
    {"red", "50%"}
  end
  defp format(_person_l) do
    # otherwise no fil
    {"none", "0%"}
  end

  defp quadrant_reverse(:ne) do
    true
  end
  defp quadrant_reverse(:nw) do
    true
  end
  defp quadrant_reverse(:se) do
    false
  end
  defp quadrant_reverse(:sw) do
    false
  end

  def line_color(relation) do
    case Enum.take(relation, -1) do
      ["M"] ->
        "#FF6EC7"
      ["P"] ->
        "blue"
      _ ->
        IEx.pry()
    end
  end

  defp add_inner_radius(sector, :circle_chart) do
    inner_radius = Cfsjksas.Chart.GetCircle.inner_radius(sector.gen)
    %Cfsjksas.Chart.Sector{sector | inner_radius: inner_radius }
  end
  defp add_inner_radius(sector, :circle_mod_chart) do
    inner_radius = Cfsjksas.Chart.GetCircleMod.inner_radius(sector.gen)
    %Cfsjksas.Chart.Sector{sector | inner_radius: inner_radius }
  end

  defp add_outer_radius(sector, :circle_chart) do
    outer_radius = Cfsjksas.Chart.GetCircle.outer_radius(sector.gen)
    %Cfsjksas.Chart.Sector{sector | outer_radius: outer_radius }
  end
  defp add_outer_radius(sector, :circle_mod_chart) do
    outer_radius = Cfsjksas.Chart.GetCircleMod.outer_radius(sector.gen)
    %Cfsjksas.Chart.Sector{sector | outer_radius: outer_radius }
  end

  defp add_lower_radians(sector, :circle_chart) do
    lower_radians = sector.sector_num * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Chart.Sector{sector | lower_radians: lower_radians }
  end
  defp add_lower_radians(%{gen: gen} = sector, :circle_mod_chart)
                        when gen in [12, 13, 14] do
    lower_radians = sector.gen11_sector_num * 2 * :math.pi() / (2 ** 11)
    %Cfsjksas.Chart.Sector{sector | lower_radians: lower_radians }
  end
  defp add_lower_radians(sector, :circle_mod_chart) do
    lower_radians = sector.sector_num * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Chart.Sector{sector | lower_radians: lower_radians }
  end

  defp add_upper_radians(sector, :circle_chart) do
    upper_radians = rem(sector.sector_num + 1, 2**sector.gen) * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Chart.Sector{sector | upper_radians: upper_radians }
  end
  defp add_upper_radians(%{gen: gen} = sector, :circle_mod_chart)
                        when gen in [12, 13, 14] do
    upper_radians = rem(sector.gen11_sector_num + 1, 2**11) * 2 * :math.pi() / (2 ** 11)
    %Cfsjksas.Chart.Sector{sector | upper_radians: upper_radians }
  end
  defp add_upper_radians(sector, :circle_mod_chart) do
    upper_radians = rem(sector.sector_num + 1, 2**sector.gen) * 2 * :math.pi() / (2 ** sector.gen)
    %Cfsjksas.Chart.Sector{sector | upper_radians: upper_radians }
  end

  defp add_points(sector, chart_type) do

    # point a is outer_radius, upper_radians
    {a_x, a_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(sector.outer_radius, sector.upper_radians)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(sector.outer_radius, sector.upper_radians)
    end
    # point b is outer_radius, lower_radians
    {b_x, b_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(sector.outer_radius, sector.lower_radians)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(sector.outer_radius, sector.lower_radians)
    end
    # point c is inner_radius, upper_radians
    {c_x, c_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(sector.inner_radius, sector.upper_radians)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(sector.inner_radius, sector.upper_radians)
    end
    # point d is inner_radius, lower_radians
    {d_x, d_y} = case chart_type do
      :circle_chart ->
        Cfsjksas.Chart.GetCircle.xy(sector.inner_radius, sector.lower_radians)
      :circle_mod_chart ->
        Cfsjksas.Chart.GetCircleMod.xy(sector.inner_radius, sector.lower_radians)
    end

    %Cfsjksas.Chart.Sector{sector | a_x: a_x, a_y: a_y,
                                b_x: b_x, b_y: b_y,
                                c_x: c_x, c_y: c_y,
                                d_x: d_x, d_y: d_y }
  end




end
