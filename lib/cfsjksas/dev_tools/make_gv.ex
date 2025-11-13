defmodule Cfsjksas.DevTools.MakeGv do
  @moduledoc """

  descendant_png/1
    inputs: (id_a)
    create gv file using descendant_file/1
    and runs graphviz to make png

  descendant_file/1
    inputs: (id_a)
    makes graphviz diagram of descendants of person id_a
    calls descendants(id_a) to make the text

  descendants/1
    inputs: (id_a)
    gets person_a via Cfsjksas.Ancestors.AgentStores
    makes header, trailer of gv using gv_start, gv_end
    uses get_all_people/2 to make list of all people
    make_edges/3 to create the edges
    make_nodes/2 to create the nodes

  get_all_people/2
    inputs: (people_list, relations_list)
    iterates thru lineages in relations_list
      calling get_people/3

  get_people/3
    inputs: people_list, this_lineage, rest_relations_list
    iterates thru the people in this_lineage
    adding their id to people_list if they weren't already there

  make_edges/3
    inputs: incoming gv text, relation_list, lineage number
    make edges for a lineage,
    iterates thru lineages in relation_list
    with different colored line, for each lineage
    by calling make_edges/4

  make_edges/4
    inputs: gvtxt, lineage, rest_relation_list, l_num
    iterates making edges for each parent/child pair in lineage

  make_nodes/2
    inputs: gvtxt, people_id_list
    iterates thru id list making a node for each
    by calling make_nodes/3

  make_nodes/3
    inputs: gvtxt, this id, rest of id's


  """
  require IEx

  @lineage_colors %{
    0 => "blue",
    1 => "red",
    2 => "green",
    3 => "orange",
    4 => "black",
    5 => "yellow",
    6 => "purple",
    7 => "cyan",
    8 => "magenta",
    9 => "lime",
    10 => "pink",
    11 => "teal",
    12 => "brown",
    13 => "olive",
    14 => "lavender",
  }

  def descendant_png(id_a) do
    # create gv file
    :ok = descendant_file(id_a)
    gv_filename = to_string(id_a) <> ".gv"
    gv_filepath = Path.join(:code.priv_dir(:cfsjksas), "static/gv/" <> gv_filename)
    png_filename = to_string(id_a) <> ".png"
    png_filepath = Path.join(:code.priv_dir(:cfsjksas), "static/gv/" <> png_filename)

    System.cmd("dot", ["-Tpng", gv_filepath, "-o", png_filepath])
  end

  def descendant_file(id_a) do
    filename = to_string(id_a) <> ".gv"
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/gv/" <> filename)
    descendants(id_a)
    |> Cfsjksas.Tools.Print.write_file(filepath)

  end
  def descendants(id_a) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)

    # find all the people that will be in the graph
    people_id_list = get_all_people([], person_a.relation_list)

    # make graph with a different color for each lineage
    gv_beg(id_a)
    |> make_edges(person_a.relation_list, 0)
    |> make_nodes(people_id_list)
    |> gv_end

  end

  defp gv_beg(id_a) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
    name_dates = Cfsjksas.Ancestors.Person.get_name_dates(person_a)

    # setup the gv from a file
    gv_beg_path = Path.join(:code.priv_dir(:cfsjksas), "static/gv/gv.header.txt")

    File.read!(gv_beg_path)
    <> 	"{edge [style=invis]; title00 -> #{to_string(id_a)};}"
    <> "\ttitle00 [shape=\"plaintext\" fillcolor=\"#ffffff\"  label=\""
    <> name_dates <> "\" fontsize=40];"
  end

  defp gv_end(gv_txt) do
    # the Charles, Jim, Ann table is in file
    p0005 = Path.join(:code.priv_dir(:cfsjksas), "static/gv/charlesjimann.txt")

    gv_txt
    <> File.read!(p0005)
    <> "\n}\n\n"
  end

  # get_all_people has 2 inputs (people_list relations_list)
  defp get_all_people(people_list, []) do
    # no more relation lists do done
    people_list
  end
  defp get_all_people(people_list, [this_lineage | rest_relations_list]) do
    get_people(people_list, this_lineage, rest_relations_list)
  end

  # get_people/3 (people_list, this_relations_list, rest_relations_list)
  defp get_people(people_list, [], rest_relations_list) do
    # this lineage done so move on to next lineage
    get_all_people(people_list, rest_relations_list)
  end
  defp get_people(people_list, lineage, rest_relations_list) do
    gen = length(lineage)
    person_l = Cfsjksas.Ancestors.GetLineages.person(gen, lineage)
    # add person if not already in list
    new_people_list =
      if person_l.id in people_list do
        people_list
      else
        [person_l.id | people_list]
      end
    # move on to next lower generation
    new_lineage = List.delete_at(lineage, -1)
    # move on to that person
    get_people(new_people_list, new_lineage, rest_relations_list)
  end

  # make edges for a lineage,
  # with different colored line, for each lineage
  ## incoming gv text, relation_list, lineage number
  defp make_edges(gvtxt, [], _l_num) do
    # done since last relation_list processed
    gvtxt
  end
  defp make_edges(gvtxt, [lineage | rest_relation_list], l_num) do
    # iterate thru the people in lineage
    make_edges(gvtxt, lineage, rest_relation_list, l_num)
  end
  defp make_edges(gvtxt, [], rest_relation_list, l_num) do
    # done since lineage done, go to next lineage
    make_edges(gvtxt, rest_relation_list, l_num + 1)
  end
  # make gv edge for top parent/child pair
  defp make_edges(gvtxt, lineage, rest_relation_list, l_num) do
    # draw edge from top person to child
    gen = length(lineage)
    parent = Cfsjksas.Ancestors.GetLineages.person(gen, lineage)
    p_id = to_string(parent.id)
    child_lineage = List.delete_at(lineage, -1)
    child = Cfsjksas.Ancestors.GetLineages.person(gen-1, child_lineage)
    c_id = to_string(child.id)
    color = @lineage_colors[l_num]

    gvtxt
    <> "\t\t{edge [arrowhead=normal, arrowtail=none, color=#{color} ];\n"
    <> "\t\t#{p_id} -> #{c_id};}\n"
    |> make_edges(child_lineage, rest_relation_list, l_num)
  end

  defp make_nodes(gvtxt, []) do
    # done
    gvtxt
  end
  defp make_nodes(gvtxt, [id_a | rest]) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)
    id_g = to_string(id_a)
    name = Cfsjksas.Ancestors.Person.get_name(person_a)
    dates = Cfsjksas.Ancestors.Person.get_dates(person_a)
    {fillcolor, style} = case person_a.sex do
      "F" ->
        {"\"#ffe0e0\"", "\"rounded,filled\""}
      "M" ->
        {"\"#e0e0ff\"", "\"solid,filled\""}
    end
    label = "\"" <> name <> "\n" <> dates <> "\""

    gvtxt
    <> "\t\t"
    <> id_g
    <> " [ shape=\"box\" fillcolor="
    <> fillcolor
    <> " style="
    <> style
    <> " label="
    <> label
    <> " ];\n"
    |> make_nodes(rest)
  end

end
