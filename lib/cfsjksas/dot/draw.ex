defmodule Cfsjksas.Dot.Draw do
  @moduledoc """
  routines for creating graphviz for each generation
  """

  require IEx

  def gen(dot, 0) do
    # initial node (gen 0 special handling)

    config = Cfsjksas.Dot.Get.config(0)

    label = config.name1 <> "\\n"
    <> config.date1 <> "\\n\\n"
    <> config.name2 <> "\\n"
    <> config.date2 <> "\\n\\n"
    <> config.name3 <> "\\n"
    <> config.date3

    id = "cfs"
    fontsize = config.font_size
    fontcolor = "black"
    url = "https://github.com/sparrell/cfs_ancestors/blob/main/Vol_02_Ships/V2_C1_Principals/1_Charles_Fisher_Sparrell"

    dot <> add_node(id, label, fontsize, fontcolor, url)

  end
  def gen(dot, gen) do
    IO.inspect(gen, label: "starting draw.gen=")
    # get list of this gen ancestors
    this_gen_list = Cfsjksas.Circle.GetRelations.person_list(gen)
    # recurse thru each one.
    gen(dot, gen, this_gen_list)
  end
  def gen(dot, _gen, []) do
    # empty list so done
    dot
  end
  def gen(dot, gen, [relation | rest]) do
    config = Cfsjksas.Dot.Get.config(gen)
    fontsize = config.font_size
    id = Enum.join(relation)
    fontcolor = find_color(relation)
    person = Cfsjksas.Circle.GetRelations.data(gen, relation)

    name = not_nil(person.given_name) <> "\\n"
    <> not_nil(person.surname) <> "\\n("
    <> not_nil(person.birth_year) <> " - "
    <> not_nil(person.death_year) <> ")"


    url = get_url(person)

    node = add_node(id, name, fontsize, fontcolor, url)
    edge = add_edge(relation, id, gen)

    # compute this ancestor and recurse to next
    gen(dot <> node <> edge, gen, rest)
  end

  def add_node(id, label, fontsize, fontcolor, url) do
    id
    <> " ["
    <> "label=\"" <> label <> "\" "
    <> "fontsize=" <> fontsize <> " "
    <> "fontcolor=" <> fontcolor <> " "
    <> "URL=\"" <> url <> "\""
    <> "]\n"
  end

  def add_edge(["P"], "P", 1) do
    # first generation parents special
    "cfs" <> " -- " <> "P\n"
  end
  def add_edge(["M"], "M", 1) do
    # first generation parents special
    "cfs" <> " -- " <> "M\n"
  end
  def add_edge(relation, id, gen) do
    # child is one less of relation
    parent = Enum.take(relation, gen - 1)
    Enum.join(parent) <> " -- " <> id <> "\n"
  end

  defp find_color(relation) do
    case Enum.take(relation, -1) do
      ["M"] ->
        "deeppink"
      ["P"] ->
        "indigo"
      _ ->
        IO.inspect(relation, label: "wrong find_color")
        IEx.pry()
    end
  end

  defp get_url(person) do
    url? = Map.has_key?(person, :urls)
    get_url(url?, person)
  end
  defp get_url(false, _person) do
    # no url map so return blank
    ""
  end
  defp get_url(true, person) do
    # has url map so return "book" url
    person.urls.book
  end

  defp not_nil(input) when is_binary(input) do
    # is string so return as is
    input
  end
  defp not_nil(input) when is_nil(input) do
    # is empty so return blank space (maybe should return question mark?)
    "?"
  end



end
