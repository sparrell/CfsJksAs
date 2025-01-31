defmodule Cfsjksas.Circle.ShipHighlight do
  @moduledoc """
  routines for coloring ships and brickwalls
  """
  require IEx

  def beyond(gen, sector, relation, person) do
    mother = Cfsjksas.Circle.GetRelations.mother(gen, relation)
    father = Cfsjksas.Circle.GetRelations.father(gen, relation)
    ship = Cfsjksas.Circle.GetPeople.ship(person.id)
    beyond_shape(mother, father, ship, sector)
  end

  defp beyond_shape(mother, father, _ship, _sector)
      when (mother != nil) and (father != nil) do
    # both parents exist so move on with no added text to svg
    ""
  end
  defp beyond_shape(nil, nil, nil, sector) do
    # no parents, no ship so it's a brick wall
    # so return red shape
    make_wedge(sector, "red")
  end
  defp beyond_shape(nil, nil, %{name: ship_name}, sector)
      when ship_name != nil do
    # no parents, with a ship is an immigrant, and ship has a name
    # so return blue shape
    make_wedge(sector, "blue")
  end
  defp beyond_shape(nil, nil, %{name: ship_name}, sector)
      when ship_name == nil do
    # no parents, with a ship is an immigrant, and ship does not have a name
    # so return light blue shape
    make_wedge(sector, "aqua")
  end
  defp beyond_shape(_mother, nil, nil, sector) do
    # mother, no father, no ship so it's a brick wall for father
    # so return red shape for father's half
    make_wedge_father(sector, "red")
  end
  defp beyond_shape(nil, _father, nil, sector) do
    # no mother, father, no ship so it's a brick wall for mother
    # so return red shape
    # return bad svg for now to find it
    make_wedge_mother(sector, "red")
  end
  defp beyond_shape(_mother, nil, %{name: ship_name}, sector)
      when ship_name != nil do
    # mother, no father, ship w name
    # so return blue shape
    make_wedge_father(sector, "blue")
  end
  defp beyond_shape(nil, _father, %{name: ship_name}, sector)
      when ship_name != nil do
    # no mother, father, ship w name
    # so return blue shape
    make_wedge_mother(sector, "blue")
  end
  defp beyond_shape(_mother, nil, %{name: ship_name}, sector)
      when ship_name == nil do
    # mother, no father, ship wo name
    # so return light blue shape
    make_wedge_father(sector, "aqua")
  end
  defp beyond_shape(nil, _father, %{name: ship_name}, sector)
      when ship_name == nil do
    # no mother, father, ship wo name
    # so return light blue shape
    make_wedge_mother(sector, "aqua")
  end
  defp beyond_shape(mother, father, ship, _sector) do
    # shouldn't get here
    IO.inspect({mother, father, ship}, label: "beyond shape")
    IEx.pry()
  end

  def make_wedge(sector, color) do
    # make wedge given sector and color

    # id of shape is wedge, gen, sector_num
    id = "wedge_" <> to_string(sector.gen) <> "_" <> to_string(sector.sector_num)

    # inner_radius of wedge is outer radius of sector
    inner_radius = sector.outer_radius
    # outer_radius of wedge is outer ring radius
    outer_radius = Cfsjksas.Circle.Get.radius(:outer_ring)

    # set stroke width arbitrailily since same color
    stroke_width = "1"

    # points CD of wedge (ie inner arc) are points AB of sector (ie outer arc)
    c_x = sector.a_x
    c_y = sector.a_y
    d_x = sector.b_x
    d_y = sector.b_y
    # points AB of wedge (ie outer arc) are same radians but at outer_radius
    ## point a is outer_radius, upper_radians
    {a_x, a_y} = Cfsjksas.Circle.Get.xy(outer_radius, sector.upper_radians)
    ## point b is outer_radius, lower_radians
    {b_x, b_y} = Cfsjksas.Circle.Get.xy(outer_radius, sector.lower_radians)

    line_color = color
    fill = color
    fill_opacity = "100%"
    Cfsjksas.Circle.Sector.make_shape_svg(id, a_x, a_y, b_x, b_y, c_x, c_y, d_x, d_y,
        inner_radius, outer_radius,
        line_color, stroke_width, fill, fill_opacity
        )
  end

  def make_wedge_mother(sector, color) do
    # make wedge on just mother's half
    gen = sector.gen + 1
    sector_num = (2 * sector.sector_num) + 1

    # id of shape is wedge, gen, sector_num
    id = "wedge_" <> to_string(gen) <> "_" <> to_string(sector_num)

    # inner_radius of wedge is outer radius of sector
    inner_radius = sector.outer_radius
    # outer_radius of wedge is outer ring radius
    outer_radius = Cfsjksas.Circle.Get.radius(:outer_ring)

    # lower radians is halfway between sector upper and lower radians
    lower_radians = (sector.lower_radians + sector.upper_radians) / 2

    # upper radians is same as sector
    upper_radians = sector.upper_radians

    # set stroke width arbitrailily since same color
    stroke_width = "1"

    # points
    # point a is outer_radius, upper_radians
    {a_x, a_y} = Cfsjksas.Circle.Get.xy(outer_radius, upper_radians)
    # point b is outer_radius, lower_radians
    {b_x, b_y} = Cfsjksas.Circle.Get.xy(outer_radius, lower_radians)
    # point c is inner_radius, upper_radians
    {c_x, c_y} = Cfsjksas.Circle.Get.xy(inner_radius, upper_radians)
    # point d is inner_radius, lower_radians
    {d_x, d_y} = Cfsjksas.Circle.Get.xy(inner_radius, lower_radians)

    line_color = color
    fill = color
    fill_opacity = "100%"

    Cfsjksas.Circle.Sector.make_shape_svg(id,
            a_x, a_y, b_x, b_y, c_x, c_y, d_x, d_y,
            inner_radius, outer_radius,
            line_color, stroke_width, fill, fill_opacity
            )
  end

  def make_wedge_father(sector, color) do
    # make wedge on just mother's half
    gen = sector.gen + 1
    sector_num = 2 * sector.sector_num

    # id of shape is wedge, gen, sector_num
    id = "wedge_" <> to_string(gen) <> "_" <> to_string(sector_num)

    # inner_radius of wedge is outer radius of sector
    inner_radius = sector.outer_radius
    # outer_radius of wedge is outer ring radius
    outer_radius = Cfsjksas.Circle.Get.radius(:outer_ring)

    # lower radians is same as sector
    lower_radians = sector.lower_radians

    # upper radians is halfway between sector upper and lower radians
    upper_radians = (sector.lower_radians + sector.upper_radians) / 2

    # set stroke width arbitrailily since same color
    stroke_width = "1"

    # points
    # point a is outer_radius, upper_radians
    {a_x, a_y} = Cfsjksas.Circle.Get.xy(outer_radius, upper_radians)
    # point b is outer_radius, lower_radians
    {b_x, b_y} = Cfsjksas.Circle.Get.xy(outer_radius, lower_radians)
    # point c is inner_radius, upper_radians
    {c_x, c_y} = Cfsjksas.Circle.Get.xy(inner_radius, upper_radians)
    # point d is inner_radius, lower_radians
    {d_x, d_y} = Cfsjksas.Circle.Get.xy(inner_radius, lower_radians)

    line_color = color
    fill = color
    fill_opacity = "100%"

    Cfsjksas.Circle.Sector.make_shape_svg(id,
            a_x, a_y, b_x, b_y, c_x, c_y, d_x, d_y,
            inner_radius, outer_radius,
            line_color, stroke_width, fill, fill_opacity
            )
  end


end
