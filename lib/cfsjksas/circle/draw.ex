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

  def gen(svg, gen, chart) do
    IO.inspect(gen, label: "starting draw.gen=")
    # get list of this gen ancestors
    this_gen_list = Cfsjksas.Ancestors.GetLineages.person_list(gen)
    # recurse thru each one.
    add_ancestor(svg, gen, chart, this_gen_list)
  end

  defp add_ancestor(svg, _gen, _chart, []) do
    # done with this gen, return
    svg
  end
  defp add_ancestor(svg, gen, chart, [this | rest]) do
    # process "this" ancestor
    person = Cfsjksas.Ancestors.GetLineages.person(gen,this)

    # determine whether to draw this ancestor or not
    ## if chart = :wo_duplicates and relation isn't first on list of dups, then don't draw
    draw? = should_draw?(chart, person.id, person.relation)
    svg = add_ancestor(draw?, svg, gen,  chart, this, person)

    # recurse thru rest of ancestors in this generation
    add_ancestor(svg, gen, chart, rest)
  end
  defp add_ancestor(false, svg, _gen,  _chart, _this, _person) do
    # do not draw this person
    svg
  end
  defp add_ancestor(true, svg, gen,  chart, this, person) do
    # draw this person

    {fill, fill_opacity} = case chart do
      :base ->
        {"none", "0%"}
      :ship ->
        {"none", "0%"}
      :duplicates ->
        # determine if duplicate
        color_dups(person.id)
      :wo_duplicates ->
        {"none", "0%"}
    end

    line_color = find_line_color(this)

    # make shape
    sector = Cfsjksas.Circle.Sector.make_shape(gen, person.sector, line_color, fill, fill_opacity)
    svg = svg <> sector.svg

    # add name
    svg = svg <> Cfsjksas.Circle.Sector.add_name(gen, person, sector)

    # add boat/brickwall if appropiate, and return the svt
    add_boat(chart, svg, gen, sector, this, person)
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

  defp add_boat(:base, svg, _gen, _sector, _this, _person) do
    # don't add anything on base
    svg
  end
  defp add_boat(:ship, svg, gen, sector, this, person) do
    svg <> Cfsjksas.Circle.ShipHighlight.beyond(gen, sector, this, person)
  end
  defp add_boat(:duplicates, svg, gen, sector, this, person) do
    svg <> Cfsjksas.Circle.ShipHighlight.beyond(gen, sector, this, person)
  end
  defp add_boat(:wo_duplicates, svg, gen, sector, this, person) do
    svg <> Cfsjksas.Circle.ShipHighlight.beyond(gen, sector, this, person)
  end

  defp color_dups(id) do
    # determine if person appears more than one time, color green if they do
    person = Cfsjksas.Ancestors.GetAncestors.person(id)
    case length(person.relation_list) do
      1 ->
        {"none", "0%"}
      _ ->
        {"green", "50%"}
    end
  end

  defp should_draw?(:wo_duplicates, id, relation) do
    # determine whether to draw this ancestor or not
    ## if chart = :wo_duplicates and relation isn't first on list of dups, then don't draw

    # get list of relations
    person = Cfsjksas.Ancestors.GetAncestors.person(id)
    relations = person.relation_list
    # find index of relation in relations
    index = Enum.find_index(relations, fn r -> r == relation end)
    # if nil, something went wrong
    # if 0, first position so draw this perons
    # if >0, then this is a dup and do not draw
    case index do
      nil ->
        # something went wrong - relation not in relations????
        IEx.pry()
      0 ->
        # first position, so draw
        true
      _ ->
        # other position, do don't draw
        false
    end

  end
  defp should_draw?(_chart, _id, _relation) do
    # determine whether to draw this ancestor or not
    ## if chart != :wo_duplicates so do draw
    true
  end


end
