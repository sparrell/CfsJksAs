# Cfsjksas

Phoenix server for ancestry data for
Charles Fisher Sparrell (CFS),
James Kirkwood Sparrell (JKS),
and Ann Sparrell (AS).

## 3 Start Phoenix

`mix phx.server` or inside IEx with:

iex -S mix phx.server

## make circle chart

Cfsjksas.Chart.Circle.main("circle.svg")

## make circlemod chart

Cfsjksas.Chart.CircleMod.main("circle_mod.svg")

## make adoc pages

* gen=3
* Cfsjksas.Tools.Markdown.person_pages(gen)
*  
* Cfsjksas.Tools.Markdown.person_pages(:all)
*  
* todo
  * fix to use new marked lineage

## add werelate links

* Restart server (to zero counters and to read in data)
  * needed to initialize data readin
  * redo whenever data changes
* Cfsjksas.Links.FindLink.update(:werelate)
* validate changes and swap temp file into data file
  * Cfsjksas.DevTools.CheckLinks.try1()
* Cfsjksas.Links.FindLink.update(:wikitree)

## restart app

* to restart app

Application.stop(:cfsjksas)

Application.start(:cfsjksas)

## update gigalixir

* git push gigalixir
* Gigalixir[https://cfsjksas.gigalixirapp.com]

## check if missing links

gen=3
Cfsjksas.Ancestors.Lineage.list_no_link_key(gen)

