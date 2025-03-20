defmodule Cfsjksas.Annuli.Draw do
  @moduledoc """
  routines for creating svg annuli for each generation
  """

  require IEx

  def ref_circle(svg) do
    {x, y} = Cfsjksas.Annuli.Get.center()
    r = Cfsjksas.Annuli.Get.radius(:outer_ring)

    svg
    <> add_comment("ref circles")
    <> add_circle(x, y, r, "indigo", "50", "100%", "none")
    <> add_circle(x, y, 500, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 800, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 1175, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 1550, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 1900, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 2400, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 3000, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 4000, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 5900, "lightgoldenrodyellow", "50", "60%", "none")
    <> add_circle(x, y, 7800, "lightgoldenrodyellow", "60", "60%", "none")
    <> add_circle(x, y, 9700, "lightgoldenrodyellow", "60", "60%", "none")
    <> add_circle(x, y, 11800, "lightgoldenrodyellow", "60", "60%", "none")
    <> add_circle(x, y, 13800, "lightgoldenrodyellow", "60", "60%", "none")
  end

  def gen(svg, 0) do
    # initial node (gen 0 special handling)
    gen = 0

    # get necessary info
    {center_x, center_y} = Cfsjksas.Annuli.Get.center()
    r = Cfsjksas.Annuli.Get.radius(gen)
    cfg = Cfsjksas.Annuli.Get.config(gen)

    svg
    <> add_comment("gen 0")
    <> add_circle(center_x, center_y, r, cfg.stroke_color, cfg.stroke_width, "100%", cfg.shape_fill)
    <> add_text(cfg.name1, center_x, center_y + cfg.delta_y_n1, cfg.n_font_family, cfg.n_font_size, cfg.text_fill)
    <> add_text(cfg.date1, center_x, center_y + cfg.delta_y_d1, cfg.d_font_family, cfg.d_font_size, cfg.text_fill)
    <> add_text(cfg.name2, center_x, center_y + cfg.delta_y_n2, cfg.n_font_family, cfg.n_font_size, cfg.text_fill)
    <> add_text(cfg.date2, center_x, center_y + cfg.delta_y_d2, cfg.d_font_family, cfg.d_font_size, cfg.text_fill)
    <> add_text(cfg.name3, center_x, center_y + cfg.delta_y_n3, cfg.n_font_family, cfg.n_font_size, cfg.text_fill)
    <> add_text(cfg.date3, center_x, center_y + cfg.delta_y_d3, cfg.d_font_family, cfg.d_font_size, cfg.text_fill)
  end
  def gen(svg, gen) do
    # draw ellipse in gen-band for each person in gen

    IO.inspect(gen, label: "starting draw.gen=")

    # get list of this gen ancestors
    this_gen_list = Cfsjksas.Ancestors.GetRelations.person_list(gen)

    # recurse thru each one.
    add_ancestor(svg, gen, this_gen_list)

  end

  def add_ancestor(svg, _gen, []) do
    # list empty so done
    svg
  end
  def add_ancestor(svg, gen, [relation | rest]) do
    # add ancestor at radius of step in gen-band and angle based on relation

    # get necessary info
    cfg = Cfsjksas.Annuli.Get.config(gen)
    person = Cfsjksas.Ancestors.GetRelations.data(gen,relation)
#
    given_name = not_nil(person.given_name)
    surname = not_nil(person.surname)

    dates = " ("
    <> not_nil(person.birth_year) <> " - "
    <> not_nil(person.death_year) <> ")"

    {x, y} = centroid(gen, cfg, person)

    # xy is center of ellipse, but need to offset text in y dimension
    gn_y = y + cfg.gn_y
    sn_y = y + cfg.sn_y
    d_y = y + cfg.d_y

    # color ellipse based on gender
    fill = find_color(relation)

    # draw line to inner generation
    child_gen = gen - 1
    child_cfg = Cfsjksas.Annuli.Get.config(child_gen)
    # child is relation with lsst item lopped off
    child_id = Enum.take(relation,length(relation)-1)
    child = Cfsjksas.Ancestors.GetRelations.data(child_gen, child_id)

    # draw relation line for 2nd-generation out
    rel_line = case gen do
      1 ->
        ""
      _ ->
        {x2, y2} = centroid(child_gen, child_cfg, child)
        add_line(x, y, x2, y2, cfg)
    end

#
#
#    # special case for gen=1 since child is center
#    {x2, y2} = case gen == 1 do
#      true -> Cfsjksas.Annuli.Get.center()
#      false -> centroid(child_gen, child_cfg, child)
#    end
#
    comment = given_name <> " " <> surname <> " " <> dates

    # add svg text for ellipse and text to existing svg and recurse
    svg
    <> add_comment(comment)
#    <> add_line(x, y, x2, y2, cfg)
    <> rel_line
    <> add_ellipse(x, y, cfg.r_x, cfg.r_y, fill, cfg.fill_opacity, cfg.stroke, cfg.stroke_width)
    <> add_text(given_name, x, gn_y, cfg.gn_font_family, cfg.gn_font_size, cfg.text_fill)
    <> add_text(surname, x, sn_y, cfg.sn_font_family, cfg.sn_font_size, cfg.text_fill)
    <> add_text(dates, x, d_y, cfg.d_font_family, cfg.d_font_size, cfg.text_fill)
    |> add_ancestor(gen, rest)
  end

  def add_circle(x, y, r, stroke_color, stroke_width, stroke_opacity, fill) do
    "<circle "
    <> "cx=\"" <> to_string(x) <> "\" "
    <> "cy=\"" <> to_string(y) <> "\" "
    <> "r=\"" <> to_string(r) <> "\" "
    <> "stroke=\"" <> stroke_color <> "\" "
    <> "stroke-width=\"" <> stroke_width <> "\" "
    <> "stroke-opacity=\"" <> stroke_opacity <> "\" "
    <> "fill=\"" <> fill <> "\"/>\n"
  end

  def add_text(text, x, y, font_family, font_size, fill) do
    # add text centered at specific spot
    "<text "
    <> "text-anchor=\"middle\" "
    <> "x=\"" <> to_string(x) <> "\" "
    <> "y=\"" <> to_string(y) <> "\" "
    <> "font-family=\"" <> font_family <> "\" "
    <> "font-size=\"" <> font_size <> "\" "
    <> "fill=\"" <> fill <> "\" "
    <> ">\n"
    <> text <> "\n"
    <> "</text>\n"
  end

  def add_ellipse(x, y, rx, ry, fill, fill_opacity, stroke, stroke_width) do
    "<ellipse "
    <> "cx=\"" <> to_string(x) <> "\" "
    <> "cy=\"" <> to_string(y) <> "\" "
    <> "rx=\"" <> to_string(rx) <> "\" "
    <> "ry=\"" <> to_string(ry) <> "\" "
    <> "stroke=\"" <> stroke <> "\" "
    <> "stroke-width=\"" <> stroke_width <> "\" "
    <> "fill-opacity=\"" <> fill_opacity <> "\" "
    <> "fill=\"" <> fill <> "\"/>\n"
  end

  defp find_color(relation) do
    case Enum.take(relation, -1) do
      ["M"] ->
        "lightpink"
      ["P"] ->
        "lightskyblue"
      _ ->
        IEx.pry()
    end
  end

  defp not_nil(input) when is_binary(input) do
    # is string so return as is
    input
  end
  defp not_nil(input) when is_nil(input) do
    # is empty so return blank space (maybe should return question mark?)
    "?"
  end

  defp centroid(gen, cfg, person) do
    # for a given person, find the center

    # get necessary info
    band_r = Cfsjksas.Annuli.Get.radius(gen) # radius of band

      # center of ellipse is band radius plus step*step_radius
    r = band_r + (rem(person.sector, cfg.steps) * cfg.step_radius)

    # angle is middle of "sector" made by dividing circle into 2n sectors
    middle = (person.sector + (person.sector + 1) ) / 2
    radians = middle * 2 * :math.pi() / (2 ** gen)

    # return {x,y}
    Cfsjksas.Annuli.Get.xy(r, radians)
  end

  def add_line(x1, y1, x2, y2, cfg) do
    # draw line for relationship
    "<line "
    <> "x1=\"" <> to_string(x1) <> "\" "
    <> "y1=\"" <> to_string(y1) <> "\" "
    <> "x2=\"" <> to_string(x2) <> "\" "
    <> "y2=\"" <> to_string(y2) <> "\" "
    <> "stroke=\"" <> cfg.line_stroke <> "\" "
    <> "stroke-width=\"" <> cfg.line_stroke_width <> "\" "
    <> "/>\n"
  end

  defp add_comment(text) do
    "<!-- "
    <> text
    <> " -->\n"
  end


end
