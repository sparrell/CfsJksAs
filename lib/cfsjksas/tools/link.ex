defmodule Cfsjksas.Tools.Link do
  @moduledoc """
  This module provides useiful utilities for making links supporting the markdown module
  - book(person) - adoc link to person's page in the book
  - dev(person) - adoc link to person in CfsJksAs app on gigalixir
  - werelate(person) - adoc link to person in werelate
  - myheritage(person) - adoc link to person in myheritage
  - geni(person) - adoc link to person in geni
  """

  @datapath "static/data/"
  @adocpath "static/temp/"

  require IEx


	@doc """
	given a person, create a hyperlink to that person
	most are 'intermediate' and auto-generated
	Terminations are special and not from this routine
	Primary (C, J, A) are special and not from this module
	"""
	def book(id_a) do
    "* "
    <> book_link(id_a)
    <> " i.e. this page\n"
	end

  def book_link(id_a) do
    # make filename and label and create link
    person_a = Cfsjksas.Chart.AgentStores.get_person_a(id_a)

#    name = person_a.given_name
#          <> " " <> cond do
#            is_nil(person_a.surname) ->
#              "Unknown"
#            true ->
#              person_a.surname
#          end
#		dates = " (" <> person_a.birth_year <> " - " <> person_a.death_year <> ")"
#xxx		link_label = "[" <> name <> dates <> "]"
    link_label = "[" <> Cfsjksas.Ancestors.Person.get_name_dates(person_a) <> "]"
    # need gen label for generation directory
    gen = person_a.label |> String.split(".") |> List.first()
    "https://github.com/sparrell/cfs_ancestors/blob/main/"
		<> "Vol_02_Ships/"
		<> "V2_C5_Ancestors/"
    <> gen <> "/"
    <> person_a.label
    <> ".adoc"
    <> link_label

  end

  def dev(person) do
		"* https://cfsjksas.gigalixirapp.com/person?p="
		<> to_string(person.id)
		<> "[Dev website]\n"
	end

  def werelate(person_p) do
    # output werelate link if present, or TBD if not
    url = Map.get(person_p.links, :werelate)
    case url do
      nil ->
      "* WeRelate TBD\n"
      _ ->
        "* "
        <> url
        <> "[WeRelate]\n"
    end
  end

	def myheritage(person_p) do
    # print myheritage link if present, or TBD if not
    url = Map.get(person_p.links, :myheritage)
    case url do
      nil ->
      "* MyHeritage TBD\n"
      _ ->
        "* "
        <> url
        <> "[MyHeritage]\n"
    end
  end

	def geni(person_p) do
    # print geni link if present, or TBD if not
    url = Map.get(person_p.links, :geni)
    case url do
      nil ->
      "* Geni TBD\n"
      _ ->
        "* "
        <> url
        <> "[Geni]\n"
    end
  end

  def wikipedia(person_p) do
    # print wikipedia link if present, or leave out if not
    url = Map.get(person_p.links, :wikipedia)
    case url do
      nil ->
      ""
      _ ->
        "* "
        <> url
        <> "[Wikipedia]\n"
    end
  end

  def wikitree(person_p) do
    # print wikipedia link if present, or leave out if not
    url = Map.get(person_p.links, :wikitree)
    case url do
      nil ->
      "* WikiTree TBD\n"
      _ ->
        "* " <> url <> "[WikiTree]\n"
    end
  end


  def relation_to_file_root(relation) do
    gen = length(relation)
    gen_str = to_string(gen)
    person_r = Cfsjksas.Ancestors.GetLineages.person(gen, relation)
    given = case person_r.given_name do
      nil ->
        "Unknown"
      _ ->
        person_r.given_name
        |> String.replace(" ", "_")
        |> String.replace(".", "")
    end
    surname = case person_r.surname do
      nil ->
        "Unknown"
      _ ->
        person_r.surname
        |> String.replace(" ", "_")
        |> String.replace(".", "")
    end

    "gen" <> gen_str <> "/"   # directory
    <> "gen" <> gen_str <> "."
    <> Enum.join(relation) <> "."
    <> given <> "_" <> surname

  end

  def make_filename(relation, :adoc) do
    # filepath for people pages
    filepath = @adocpath
    <> relation_to_file_root(relation)
    <> ".adoc"

    Path.join(:code.priv_dir(:cfsjksas), filepath )
  end
  def make_filename(relation, :md) do
    # filepath for people pages
    filepath = @datapath
    <> relation_to_file_root(relation)
    <> ".md"

    Path.join(:code.priv_dir(:cfsjksas), filepath )
  end



end
