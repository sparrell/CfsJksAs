defmodule Cfsjksas.Create.Hybrid do
    @moduledoc """
  routines for creating SVG "hybrid" Chart
  """

  @doc """
  input: filename
  output: file written with SVG chart

  uses relation file, with duplicate ancestors stripped out
  uses circle chart for inner generations
  kludges outmost generations for readability and to fit
  """

  require DateTime
  require IEx


  def main(filename) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)

    # get relations data and remove duplicates in it
    Cfsjksas.Tools.Relation.dedup()
    |> svg_beg()
    |> draw_gen()
    |> svg_end()
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

    IO.inspect(filename, label: "created chart")


  end


  defp svg_beg(relations) do
    #<svg viewBox="0 0 10000 10000" xmlns="http://www.w3.org/2000/svg">
    #{x_num,y_num} = Cfsjksas.Circle.Get.viewbox()
    #x = to_string(x_num)
    #y = to_string(y_num)
    {relations,
    #"<svg viewBox=\"0 0 " <> to_string(x) <> " " <> to_string(y)
    #  <> "\" xmlns=\"http://www.w3.org/2000/svg\">\n"
    "<svg viewBox=\"7000 0 42000 42000\" xmlns=\"http://www.w3.org/2000/svg\">"
    }
  end

  def svg_end(svg) do
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

  def draw_gen({relations, svg}) do
    # initial circle
    IO.inspect("starting draw.gen=0")
    gen = 0
    sector_num = 0
    line_color = "black"
    fill = "none"
    fill_opacity = "50%"
    sector = Cfsjksas.Circle.Sector.make_shape(gen, sector_num, line_color, fill, fill_opacity)
    # go to next generation
    draw_gen({relations,
      svg <> sector.svg},
      1
      )
  end
  def draw_gen({_relations, svg}, 15) do
    # reached top gen so finish returning just svg
    svg
  end
  def draw_gen({relations, svg}, gen) do

    # get list of this gen ancestors
    this_gen_list = Map.keys(relations[gen])
    num_anc = length(this_gen_list)
    IO.inspect({gen, num_anc}, label: "gen = #anc")

    # recurse thru each one.
    new_svg = add_ancestor({relations, svg}, gen, this_gen_list)

    # and then go to next up generation
    draw_gen({relations, new_svg}, gen+1)
  end

  def add_ancestor({_relations, svg}, _gen, []) do
    # this_gen_list is empty so done
    svg
  end
  def add_ancestor({relations, svg}, gen, [this_relation | rest_in_this_gen]) do
    person = relations[gen][this_relation]

    # determine line color based on whether person is a father or mother
    line_color = case Enum.take(this_relation, -1) do
      ["M"] ->
        "#FF6EC7"
      ["P"] ->
        "blue"
      _ ->
        IEx.pry()
    end

    {fill, fill_opacity} = case person.termination do
      :normal ->
        # not termination
        {"none", "0%"}
      :ship ->
        {"dodgerblue", "10%"}
      :no_ship ->
        {"lightskyblue", "10%"}
      :duplicate ->
        {"lightgreen", "50%"}
      :brickwall_both ->
        {"red", "50%"}
      :brickwall_mother ->
        {"red", "30%"}
      :brickwall_father ->
        {"red", "30%"}
      _ ->
        IEx.pry()
    end

        # make shape
    sector = Cfsjksas.Circle.Sector.make_shape(gen, person.sector, line_color, fill, fill_opacity)
    svg = svg <> sector.svg

    # add name
    svg = svg <> Cfsjksas.Circle.Sector.add_name(gen, person, sector)

    # recurse thru rest of this gen's list
    add_ancestor({relations, svg}, gen, rest_in_this_gen)
  end


end
