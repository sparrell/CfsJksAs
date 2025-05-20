defmodule Cfsjksas.Hybrid.Create do
    @moduledoc """
  routines for creating SVG "hybrid" Chart
  """

  require DateTime
  require IEx



  @doc """
  input: filename
  output: file written with SVG chart

  uses relation file, with duplicate ancestors stripped out
  uses circle chart for inner generations
  kludges outmost generations for readability and to fit
  """
  def main(filename) do
    # get relations data and remove duplicates in it

    {Cfsjksas.Hybrid.Svg.beg(), Cfsjksas.Tools.Relation.dedup()}
    |> draw_gen()
    |> Cfsjksas.Hybrid.Svg.finish()
    |> Cfsjksas.Hybrid.Svg.save_file(filename)

    IO.inspect(filename, label: "created chart")

  end


  def draw_gen({svg, relations}) do
    # initial circle
    IO.inspect("starting draw.gen=0")
    gen = 0
    sector_num = 0
    line_color = "black"
    fill = "none"
    fill_opacity = "50%"
    sector = Cfsjksas.Hybrid.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # go to next generation
    draw_gen({svg <> sector.svg, relations}, 1)
  end
  def draw_gen({svg, relations}, gen) when gen in 0..14 do

    # get list of this gen ancestors
    this_gen_list = Map.keys(relations[gen])
    num_anc = length(this_gen_list)
    IO.inspect({gen, num_anc}, label: "gen = #anc")

    # recurse thru each one.
    new_svg = add_ancestor({relations, svg}, gen, this_gen_list)

    # and then go to next up generation
    draw_gen({new_svg, relations}, gen+1)
  end
  def draw_gen({svg, relations}, 13) do
    # special case
    # individually place each
    this_gen_list = Map.keys(relations[13])
    num_anc = length(this_gen_list)
    IO.inspect(num_anc, label: "gen 13 has #anc")
    IO.inspect(this_gen_list)
    IEx.pry()
    svg
  end
  def draw_gen({svg, _relations}, 14) do
    svg
  end
  def draw_gen({svg, _relations}, 15) do
    # reached top gen so finish returning just svg
    svg
  end

  def add_ancestor({_relations, svg}, _gen, []) do
    # this_gen_list is empty so done
    svg
  end
  def add_ancestor({relations, svg}, gen, [this_relation | rest_in_this_gen]) do
    person = relations[gen][this_relation]

    # determine line color based on whether person is a father or mother
    line_color = Cfsjksas.Hybrid.Get.line_color(this_relation)

    {fill, fill_opacity} = Cfsjksas.Hybrid.Get.fill(person.termination)

        # make shape
    sector = Cfsjksas.Hybrid.Sector.make_shape(gen, person.sector, line_color, fill, fill_opacity)
    svg = svg <> sector.svg

    # add name
    svg = svg <> Cfsjksas.Hybrid.Sector.add_name(gen, person, sector)

    # recurse thru rest of this gen's list
    add_ancestor({relations, svg}, gen, rest_in_this_gen)
  end

  def custom_sector({relations, svg}, gen, [["M", "M", "M", "M", "P", "M", "M", "M", "P", "P", "M", "M", "M"] | rest_in_this_gen]) do

    # recurse thru rest of this gen's list
    custom_sector({relations, svg}, gen, rest_in_this_gen)
  end


end
