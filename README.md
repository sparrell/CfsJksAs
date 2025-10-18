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

## todo

* make all agent_stores
* expand the 14/13=>12 to 14/13/12=>11
* make adoc pages displayed by dev website instead of map
  * have adoc, have html, direct works, links don't work
* refactor the other graphs
* strip out cruft

## Genealogy to do

* add in Fisher

* Lester line - mine different from wikitree

Mary Pickett

* daughter of Ruth Brewster prb
* need to add lineage to Jonathan, William, Mary Brewters
* husband John Pickett - add him and his ancestors

--------------------------------------------

## Cruft beyond here

make dedup file (usually won't need to)

Cfsjksas.Tools.Relation.dedup()

Charts created via

* Cfsjksas.Circle.Create.main(chart, filename)
  * chart
    * :base
    * :ship
    * :duplicates
    * :wo_duplicates
  * filename
    * Path.join(:code.priv_dir(:cfsjksas),filename)
      * "static/images/ancestors.svg"
      * ancestors_basic
      * ancestors_circle_ship
      * ancestors_dups
      * ancestors_no_dups

Cfsjksas.Circle.Create.main(:base, "try1.svg")
Cfsjksas.Circle.Create.main(:ship, "try2.svg")
Cfsjksas.Circle.Create.main(:duplicates, "try3.svg")
Cfsjksas.Circle.Create.main(:wo_duplicates, "try4.svg")
Cfsjksas.Create.Circle.main(:circle_base, "try5.svg")

## newest

Cfsjksas.Hybrid.Create.main("hybrid.3.svg")

Cfsjksas.Tools.Markdown.person_pages(1)

Cfsjksas.Tools.Relation.dedup()

Cfsjksas.Annuli.Create.make_annuli(:annuli_base, "ancestors_annuli.svg")

  Redesign notes:

* map of 14 generations
** map of sectors per generations - start with all blank
* for base:
** add people to appropriate sector
* for "full circle"
  * base
  * add blue/aqua/red sectors filling in blanks
* for full circle with dups marked
  * base
  * remove dups replacing with green
  * add blue/aqua/red sectors filling in blanks
* for base with dups marked
  * base
  * mark dups with green
* for 'one out'
  * base
  * remove dups replacing with one sector of green
  * and one sector of blue/aqua/red
* draw map
* ignore nils
* draw sectors

## change raw data

## start with static/data/people_ex.txt

## do whatever to change data

outtext = Cfsjksas.Tools.Print.format_ancestor_map()

## write it out

Cfsjksas.Tools.Print.write_file(outtext, filename)

## all in one

### put relation data, dedupping in ancestors

## primary relation

## branch relations (green)

## duplicate relations (invisible)

Cfsjksas.Tools.Transform.write_mom_dad()

{relations, ancestors, processed_a_id_list} = Cfsjksas.Tools.Transform.dup_lineage(); :ok

Cfsjksas.Ancestors.Stats.relations_count(relations, :termination)

Cfsjksas.Ancestors.Stats.ancestor_count(ancestors, :termination)

## create ancestors first either 3 commands up or run from _ex.txt

Cfsjksas.Ancestors.LineEnd.classify(ancestors)


## lineages

lineages = Cfsjksas.Tools.Relation.make_lineages(); :ok

sectors = Cfsjksas.Tools.Relation.make_sector_lineages(lineages); :ok

gen = 0
Cfsjksas.Tools.Relation.sector_helper(sectors, gen)

marked = Cfsjksas.Tools.Relation.mark_lineages(sectors); :ok

Cfsjksas.Tools.Script.setup()

Cfsjksas.Links.FindLink.werelate(:p0005)
