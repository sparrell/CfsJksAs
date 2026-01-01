defmodule Cfsjksas.DevTools.MakeAncestorGv do
  @moduledoc """

   ancestor_png/1
    inputs: (id_a)
    create gv file using ancestors/1
    and runs graphviz to make png

  ancestor_file/1
    inputs: (id_a)
    makes graphviz diagram of ancestors of person id_a
    calls ancestors(id_a) to make the text

  ancestors/1
    inputs: (id_a)
    gets person_a via Cfsjksas.Ancestors.AgentStores
    makes header, trailer of gv using gv_start, gv_end
    uses get_all_people/2 to make list of all people
    make_edges/3 to create the edges
    make_nodes/2 to create the nodes
  """

  require IEx

  def ancestor_png(id_a) do
    {gv_path, png_path} = filenames(id_a)

    # create gv file
    ancestors(id_a)
    |> make_gv(id_a)
    |> Cfsjksas.Tools.Print.write_file(gv_path)

    # create png
    System.cmd("dot", ["-Tpng", gv_path, "-o", png_path])
  end

  defp ancestors(id_a) do

    # initialize a people_to_do list
    to_do = [id_a]
    # initialize a node map
    nodes = []
    # initialize an edge list
    edges = []

    {nodes, edges, to_do}
    |> get_ancestors()
  end

  defp get_ancestors({nodes, edges, []}) do
    # done since empty todo
    ## return data to make graph
    {nodes, edges}
  end

  defp get_ancestors({nodes, edges, [this_id_a | rest]}) do
    # get data for next person in todo list
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(this_id_a)

    {nodes, edges, rest}
    # if person has a father, add father to the to_do list and add child-father edge to edges
    |> add_father(person_a)
    # if person has a mother, add mother to the to_do list and add child-mother edge to edges
    |> add_mother(person_a)
    # add this person to nodes
    |> add_node(person_a)
    # iterate to next person on todo
    |> get_ancestors()
  end

  defp make_gv({nodes, edges}, id_a) do
    # make graph
    gv_beg(id_a)
    |> make_edges(edges)
    |> make_nodes(nodes)
    |> gv_end

  end

  defp filenames(id_a) do
    gv_name = to_string(id_a) <> "_ancestors.gv"
    gv_path = Path.join(:code.priv_dir(:cfsjksas), "static/gv/" <> gv_name)
    png_name = to_string(id_a) <> "_ancestors.png"
    png_path = Path.join(:code.priv_dir(:cfsjksas), "static/gv/" <> png_name)
    {gv_path, png_path}

  end

  defp add_father({nodes, edges, to_do}, %{father: nil}) do
    # person_a does not have father so leave unchanged
    {nodes, edges, to_do}
  end
  defp add_father({nodes, edges, to_do}, %{father: father_id_a} = person_a)
        when is_atom(father_id_a) do
    # person_a does have father

    # add child-father edge to edges and add father to the to_do list
    {nodes, [{person_a.id, father_id_a} | edges ], [father_id_a | to_do]}
  end

  defp add_mother({nodes, edges, to_do}, %{mother: nil}) do
    # person_a does not have mother so leave unchanged
    {nodes, edges, to_do}
  end
  defp add_mother({nodes, edges, to_do}, %{mother: mother_id_a} = person_a)
        when is_atom(mother_id_a) do
    # person_a does have mother

    # add child-mother edge to edges and add mother to the to_do list
    {nodes, [{person_a.id, mother_id_a} | edges ], [mother_id_a | to_do]}
  end

  defp add_node({nodes, edges, to_do}, %{id: id}) do
      if id in nodes do
        # person aleady there so nothing to add
        {nodes, edges, to_do}
      else
        # add person to node list
        {[id | nodes], edges, to_do}
      end
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
    gv_txt
    <> "\n}\n\n"
  end

  defp make_edges(gv_text, []) do
    # no edges left, done
    gv_text
  end
  defp make_edges(gv_text, [{child_id, parent_id} | rest_edges]) do
    gv_text
    <> "\t#{to_string(child_id)} -> #{to_string(parent_id)};\n"
    |> make_edges(rest_edges)
  end

  defp make_nodes(gv_text, []) do
    # no nodes left, done
    gv_text
  end
  defp make_nodes(gv_text, [id_a | rest_nodes]) do
    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(id_a)

    fillcolor = case person_a.sex do
      "M" -> "#e0e0ff"
      "F" -> "#ffe0e0"
    end

    name = Cfsjksas.Ancestors.Person.get_name(person_a)
    dates = Cfsjksas.Ancestors.Person.get_dates(person_a)
    id = inspect(id_a)
    mother_id = inspect(person_a.mother)
    father_id = inspect(person_a.father)
    book_label = person_a.label

    label = "#{name}\n#{dates}\nid: #{id}\nmother: #{mother_id}\nfather: #{father_id}\nlabel: #{book_label}\n"

    gv_text
    <>   "\t#{to_string(id_a)} [ shape=\"box\" fillcolor=\"#{fillcolor}\" style=\"solid,filled\" label=\"#{label}\" ];\n"
    |> make_nodes(rest_nodes)
  end

end
