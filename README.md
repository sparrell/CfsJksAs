# Cfsjksas

Phoenix server for ancestry data for
Charles Fisher Sparrell (CFS),
James Kirkwood Sparrell (JKS),
and Ann Sparrell (AS).

## 3 Start Phoenix

`mix phx.server` or inside IEx with:

iex -S mix phx.server

## make both circle graphs

Cfsjksas.DevTools.Run.graphs()

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

* validate gigalixir set as remote
  * git remote -v (see if already set as remote. If yes, done. If not continue to next bullet)
  * gigalixir (ie validate gigalixir installed, and command works at shell prompt)
  * gigalixir account (ie validate initialized with account info)
  * gigalixir apps (list apps)
  * gigalixir git:remote cfsjksas (adds remote)

* git push gigalixir
* Gigalixir[https://cfsjksas.gigalixirapp.com]

* Check deploy status with:      gigalixir ps -a cfsjksas
* Check your app logs with:      gigalixir logs -a cfsjksas
* check page itself (incl that version updated)    cfsjksas.gigalixirapp.com/

* once up and running, don't forget to update dev version to next number

## stack trace

Process.info(self(), :current_stacktrace) |> elem(1) |> Enum.drop(2) |> Enum.each(fn entry -> IO.puts(Exception.format_stacktrace_entry(entry)) end)

## list ids

Cfsjksas.DevTools.ListIds.all()

## check if missing links

gen=3
Cfsjksas.Ancestors.Lineage.list_no_link_key(gen)

## scratch area

Mary is p0584

Ruth is p0207

Cfsjksas.DevTools.AncestorRelations.check([:p0584])

Cfsjksas.DevTools.AncestorRelations.check([:p0001])

Cfsjksas.Ancestors.AgentStores.line_to_id_a() |> Cfsjksas.Ancestors.LinesToPeople.create_people_map()

if person_a.id == :p0322, do: IEx.pry()

if person_a.id == :p9951, do: IEx.pry()

id_l
{11, :nw, 891}

relation: [:p, :m, :m, :p, :m, :m, :m, :m, :p, :m, :m],
  