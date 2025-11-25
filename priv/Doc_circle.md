# Documentation for making circle and circle_mod graphs

## command

### make circle chart

Cfsjksas.Chart.Circle.main("circle.svg")

### make circlemod chart

Cfsjksas.Chart.CircleMod.main("circle_mod.svg")

## Main

Cfsjksas.Chart.CircleMod.main(file_to_write)

* gets marked lineages
  * Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
* draw the chart
  * Cfsjksas.Chart.Draw.main(:circle_mod_chart)
* save the file
  * Cfsjksas.Chart.Svg.save_file(filename, :circle_mod_chart)

## Draw

Cfsjksas.Chart.Draw.main(, marked_lineages, :circle_mod_chart)

* header stuff |> draw recursing thu the generations |> trailer stuff
* each gen gets config and uses draw_gen
* draw_gen recurses thru the people using draw_person
* draw_person uses Cfsjksas.Chart.Svg.draw_sector to actually add the svg

## Svg

* draw_sector pattern matches on persons termination type
  * calls Cfsjksas.Chart.Sector.make to create sector data to feed
  * Svg.make_shape_svg
    * uses make_name_text, make_hidden_arc,
