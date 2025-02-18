defmodule Cfsjksas.Circle.Draw do
  @moduledoc """
  routines for creating Gen arcs and text
  """
  require IEx

  def gen(svg) do
    # initial circle
    IO.inspect("starting draw.gen=0")
    gen = 0
    sector_num = 0
    line_color = "black"
    fill = "none"
    fill_opacity = "50%"
    sector = Cfsjksas.Circle.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # return svg of initial + circle
    svg <> sector.svg
  end

  def gen(svg, gen) do
    IO.inspect(gen, label: "starting draw.gen=")
    # get list of this gen ancestors
    this_gen_list = Cfsjksas.Circle.GetRelations.person_list(gen)
    # recurse thru each one.
    add_ancestor(svg, gen, this_gen_list)
  end

  defp add_ancestor(svg, _gen, []) do
    # done with this gen, return
    svg
  end
  defp add_ancestor(svg, gen, [this | rest]) do
    # process "this" ancestor
    person = Cfsjksas.Circle.GetRelations.data(gen,this)
    if not is_map(person) do
      IEx.pry()
    end
    fill = "none"
    fill_opacity = "0%"
    line_color = find_line_color(this)

    # make shape
    sector = Cfsjksas.Circle.Sector.make_shape(gen, person.sector, line_color, fill, fill_opacity)
    svg = svg <> sector.svg

    # add name
    svg = svg <> Cfsjksas.Circle.Sector.add_name(gen, person, sector)

    # add boat/brickwall if appropiate
    svg = svg <> Cfsjksas.Circle.ShipHighlight.beyond(gen, sector, this, person)

    # recurse thru rest of ancestors in this generation
    add_ancestor(svg, gen, rest)
  end

  defp find_line_color(relation) do
    case Enum.take(relation, -1) do
      ["M"] ->
        "#FF6EC7"
      ["P"] ->
        "blue"
      _ ->
        IEx.pry()
    end
  end

end
