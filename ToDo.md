# junk file for notes for work in progress

## brickwalls

* father of Mary Powers

## gen in progress

* Mary Powers
  * [myheritage](https://www.myheritage.com/profile-OYYV6NML2DHJUFEXHD45V4W32Y6KPTI-23001117/mary-powers-satterlee)
  * [relative geni](https://www.geni.com/people/Capt-William-Satterlee/6000000008944272791)
  * [huband on wikitree](https://www.wikitree.com/wiki/Satterlee-80)
  * [Mary on wikitree ](https://www.wikitree.com/wiki/Powers-1437)
    * uncertain father
    * certain mother [Jemina Billings](https://www.wikitree.com/wiki/Billings-1513)
    * Daughter of Ebenezer Billings and Ann (Comstock) Billings
  * [ebenezer](https://www.wikitree.com/wiki/Billings-45) solider in King Phillips war - prob not - do research
  * [Ann Comstock (wife of Eb, mother of Jemina)](https://www.wikitree.com/wiki/Comstock-40)
  * Ann Daughter of Daniel Comstock and Paltiah (Elderkin) Comstock
  * [Daniel Comstock immigrant ](https://www.wikitree.com/wiki/Comstock-147)
  * Paltiah https://www.wikitree.com/wiki/Elderkin-29 us-born, daughter of John Elderkin Jr. and Abigail Kingsland
  * John Elkerkin Jr immigrant https://www.wikitree.com/wiki/Elderkin-19
  * Abigail Kingsland immigrant https://www.wikitree.com/wiki/Kingsland-5

## brickwalls conceding on

* Mary Powers (p0856) mother
* Ebenezer Billings (p9997) mother



## todo

* still has Cfsjksas.Circle routine which needs to be moved
* make all agent_stores
* make adoc pages displayed by dev website instead of map
  * have adoc, have html, direct works, links don't work
* refactor the other graphs
* strip out cruft
* add tony kennedy to cousins

## Genealogy to do

* add in Fisher

* Lester line - mine different from wikitree

Mary Pickett

* daughter of Ruth Brewster prb
* need to add lineage to Jonathan, William, Mary Brewters
* husband John Pickett - add him and his ancestors

* Rhode Island Genealogical Society https://rigensoc.org/cpage.php?pt=13
* Willard Family Association
* check out avery book https://archive.org/details/grotonaveryclan01aver/page/162/mode/2up

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
