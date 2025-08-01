# Cfsjksas

Phoenix server for ancestry data for
Charles Fisher Sparrell (CFS),
James Kirkwood Sparrell (JKS),
and Ann Sparrell (AS).

# Start Phoenix endpoint with `mix phx.server` or inside IEx with:
  iex -S mix phx.server

# make dedup file (usually won't need to)
Cfsjksas.Tools.Relation.dedup()

# make svg
Cfsjksas.Hybrid.Create.main("hybrid.2.svg")

# check if missing links
gen=3
Cfsjksas.Ancestors.Lineage.list_no_link_key(gen)

# make pages for other repo
gen=3
Cfsjksas.Tools.Markdown.person_pages(gen)


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
Cfsjksas.Create.Hybrid.main("try6.svg")
Cfsjksas.Hybrid.Create.main("try8.svg")
Cfsjksas.Hybrid.Create.main("try9.svg")

Cfsjksas.Hybrid.Create.main("hybrid.2.svg")

Cfsjksas.Tools.Markdown.person_pages(1)

Cfsjksas.Tools.Relation.dedup()

Cfsjksas.Annuli.Create.make_annuli(:annuli_base, "ancestors_annuli.svg")



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


## change raw data
# start with static/data/people_ex.txt
ancestors = Cfsjksas.Ancestors.GetAncestors.all_ancestors()
# do whatever to change data
outtext = Cfsjksas.Tools.Print.format_ancestor_map()
# write it out
Cfsjksas.Tools.Print.write_file(outtext, filename)



### put relation data, dedupping in ancestors
# primary relation
# branch relations (green)
# duplicate relations (invisible)


Cfsjksas.Tools.Transform.write_mom_dad()
