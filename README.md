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
        o ancestors_no_dups_ships

Cfsjksas.Circle.Create.main(:base, "try1.svg")
Cfsjksas.Circle.Create.main(:ship, "try2.svg")
Cfsjksas.Circle.Create.main(:duplicates, "try3.svg")

  * Start Phoenix endpoint with `mix phx.server` or inside IEx with:
  iex -S mix phx.server

