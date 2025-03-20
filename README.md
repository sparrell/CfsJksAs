# Cfsjksas

Phoenix server for ancestry data for
Charles Fisher Sparrell (CFS),
James Kirkwood Sparrell (JKS),
and Ann Sparrell (AS).

Charts created via
  * Cfsjksas.Circle.Create.main(chart, filename)
    + chart
      - :base
      - :ship
      - :duplicates
      - :wo_duplicates
    + filename
      - Path.join(:code.priv_dir(:cfsjksas),filename)
        o "static/images/ancestors.svg"
        o ancestors_basic
        o ancestors_circle_ship
        o ancestors_dups
        o ancestors_no_dups

Cfsjksas.Circle.Create.main(:base, "try1.svg")
Cfsjksas.Circle.Create.main(:ship, "try2.svg")
Cfsjksas.Circle.Create.main(:duplicates, "try3.svg")
Cfsjksas.Circle.Create.main(:wo_duplicates, "try4.svg")

Cfsjksas.Create.Circle.main(:circle_base, "try5.svg")


  * Start Phoenix endpoint with `mix phx.server` or inside IEx with:
  iex -S mix phx.server


  Redesign notes:
  * map of 14 generations
    + map of sectors per generations - start with all blank
  * for base:
    + add people to appropriate sector
  * for "full circle"
    + base
    + add blue/aqua/red sectors filling in blanks
  * for full circle with dups marked
    + base
    + remove dups replacing with green
    + add blue/aqua/red sectors filling in blanks
  * for base with dups marked
    + base
    + mark dups with green
  * for 'one out'
    + base
    + remove dups replacing with one sector of green
    + and one sector of blue/aqua/red
  * draw map
    + ignore nils
    + draw sectors


