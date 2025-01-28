defmodule Cfsjksas.Circle.ShipHighlight do
  @moduledoc """
  routines for coloring ships and brickwalls
  """
  require IEx

  def beyond(gen, _sector, relation, person) do
    mother = Cfsjksas.Circle.GetRelations.mother(gen, relation)
    father = Cfsjksas.Circle.GetRelations.father(gen, relation)
    ship = Cfsjksas.Circle.GetPeople.ship(person.id)
    beyond_shape(mother, father, ship)
  end

  defp beyond_shape(mother, father, _ship)
      when (mother != nil) and (father != nil) do
    # both parents exist so move on with no added text to svg
    ""
  end
  defp beyond_shape(nil, nil, nil) do
    # no parents, no ship so it's a brick wall
    # so return red shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, nil, nil) -->\n"
  end
  defp beyond_shape(nil, nil, ship = %{name: ship_name})
      when ship_name != nil do
    # no parents, with a ship is an immigrant, and ship has a name
    # so return blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, nil, ship w name) -->\n"
  end
  defp beyond_shape(nil, nil, ship = %{name: ship_name})
      when ship_name == nil do
    # no parents, with a ship is an immigrant, and ship does not have a name
    # so return light blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, nil, ship wo name) -->\n"
  end
  defp beyond_shape(_mother, nil, nil) do
    # mother, no father, no ship so it's a brick wall for father
    # so return red shape
    # return bad svg for now to find it
    "<!-- beyond_shape(mother, nil, nil) -->\n"
  end
  defp beyond_shape(nil, _father, nil) do
    # no mother, father, no ship so it's a brick wall for mother
    # so return red shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, father, nil) -->\n"
  end
  defp beyond_shape(_mother, nil, ship = %{name: ship_name})
      when ship_name != nil do
    # mother, no father, ship w name
    # so return blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(mother, nil, ship w name) -->\n"
  end
  defp beyond_shape(nil, _father, ship = %{name: ship_name})
      when ship_name != nil do
    # no mother, father, ship w name
    # so return blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, father, ship w name) -->\n"
  end
  defp beyond_shape(_mother, nil, ship = %{name: ship_name})
      when ship_name == nil do
    # mother, no father, ship wo name
    # so return light blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(mother, nil, ship wo name) -->\n"
  end
  defp beyond_shape(nil, _father, ship = %{name: ship_name})
      when ship_name == nil do
    # no mother, father, ship wo name
    # so return light blue shape
    # return bad svg for now to find it
    "<!-- beyond_shape(nil, father, ship wo name) -->\n"
  end
  defp beyond_shape(mother, father, ship) do
    # shouldn't get here
    IO.inspect({mother, father, ship}, label: "beyond shape")
    IEx.pry()
  end

end
