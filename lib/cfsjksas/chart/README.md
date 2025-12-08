# design docs for making circle charts

## commands

Cfsjksas.Chart.Circle.main("circle.svg")

Cfsjksas.Chart.CircleMod.main("circle_mod.svg")

## make circle chart

Cfsjksas.Chart.Circle.main("circle.svg")
makes the 'full' (including duplicates) circle chart.

It is a simple pipe:

```elixir
    Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
    |> Cfsjksas.Chart.Draw.main(:circle_chart)
    |> Cfsjksas.Chart.Svg.save_file(filename, :circle_chart)
```

* Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
  * gets the precomputed marked lineages data
* Cfsjksas.Chart.Draw.main(marked, :circle_chart)
  * takes in all marked lineage, puts out complete svg
  * Detail
    * create svg header stuff
      * Cfsjksas.Chart.Svg.beg(chart_type)
    * recurse thru the 14 generations calling draw(generation)
      * adds a comment (boundary of gen) Cfsjksas.Chart.Svg.comment
      * loops thru all the people in a gen
        * gets configuration Cfsjksas.Chart.GetCircle.config().sector[gen]
        * adds a comment (name of person) Cfsjksas.Chart.Svg.comment
        * draws each person draw_person
          * Cfsjksas.Chart.Svg.draw_sector using
            * Cfsjksas.Ancestors.AgentStores.get_person_a
            * Cfsjksas.Chart.Sector.make
              * Cfsjksas.Chart.GetCircle.outer_radius, inner_radius, xy,
              * still has Circle routine which need to be moved
* Cfsjksas.Chart.Svg.finish(pipeinput svg text?)
  * fill in
* Cfsjksas.Chart.Svg.save_file(svgtext, filename, :circle_chart)
  * puts svgtext in file called filename approriate for circle chart

## make circlemod chart
