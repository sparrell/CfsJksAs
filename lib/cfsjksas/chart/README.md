# design docs for making circle charts

## startup (common to all tasks)

At startup, the people_ex.txt file is processed:

* Cfsjksas.Ancestors.StoreAncestor
  * parses people_ex.txt
  * makes ancestor map available via agent store
    * Cfsjksas.Ancestors.AgentStores.get_ancestors() get entire map
    * Cfsjksas.Ancestors.AgentStores.get_ancestors(id_a) get one person from map
    * Cfsjksas.Ancestors.AgentStores.all_a_ids get all ancestor id_a's
* Cfsjksas.Ancestors.StoreLinesToIdA
  * runs previous to get ancestors and makes lines map
  * stores map as text in lines_to_id_a_ex.txt
  * made available via agent store
    * Cfsjksas.Ancestors.AgentStores.all_lines() get map of all lines
    * Cfsjksas.Ancestors.AgentStores.line_to_id_a(line) get id_a for a line
    * Cfsjksas.Ancestors.AgentStores.line_to_person_a(line) get the ancestor for a line
    * Cfsjksas.Ancestors.AgentStores.line_to_label(line) get the label for a line
* Cfsjksas.Ancestors.StoreIdAToLines
  * runs previous to get all lines and resorts into map keyed by id_a
  * stores map as text in id_a_to_lines_ex.txt
  * made available via agent store
    * Cfsjksas.Ancestors.AgentStores.id_a_to_line() return entire map
    * Cfsjksas.Ancestors.AgentStores.id_a_to_line(id_a) return the lines for one person
* Cfsjksas.Ancestors.StoreMarkedSectors
  * process create a map by circle sector ie {gen, quadrant, sector} eg {3, :ne, 2}
  * marked means including the brickwall, duplicate, immigrant fields
  * stores map as text in marked_sectors_ex.txt
  * made available via agent store
    * Cfsjksas.Ancestors.AgentStores.get_marked_sector_map() return whole map
    * Cfsjksas.Ancestors.AgentStores.get_all_sector_ids() all the sector ids in sorted list
    * Cfsjksas.Ancestors.AgentStores.all_m_ids same as previous????
    * rm. one of above?

## commands

Make circle chart including duplicates (dark green for branch, light green for beyond branch)

* Cfsjksas.Chart.Circle.main("circle.svg")

Make circle chart with only 'branch' duplicate

* Cfsjksas.Chart.CircleMod.main("circle_mod.svg")

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

* Cfsjksas.Ancestors.AgentStores.get_marked_lineages()
  * gets the precomputed marked lineages data
* Cfsjksas.Chart.Draw.main(marked, :circle_mod_chart)
  * takes in all marked lineage, puts out complete svg
  * Detail
    * create svg header stuff
      * Cfsjksas.Chart.Svg.beg(chart_type)
    * recurse thru the 14 generations calling draw(generation)
      * adds a comment (boundary of gen) Cfsjksas.Chart.Svg.comment
      * loops thru all the people in a gen
        * gets configuration Cfsjksas.Chart.GetCircleMod.config().sector[gen]
        * adds a comment (name of person) Cfsjksas.Chart.Svg.comment
        * draws each person draw_person
          * Cfsjksas.Chart.Svg.draw_sector using
            * Cfsjksas.Ancestors.AgentStores.get_person_a
            * skips person if :redundant
            * Cfsjksas.Chart.Sector.make
              * Cfsjksas.Chart.GetCircle.outer_radius, inner_radius, xy,
              * still has Circle routine which need to be moved
    * Cfsjksas.Chart.Svg.finish(pipeinput svg text?)
      * fill in
* Cfsjksas.Chart.Svg.save_file(svgtext, filename, :circle_mod_chart)
  * puts svgtext in file called filename approriate for circle_mod_chart
