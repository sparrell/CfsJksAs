defmodule Cfsjksas.Tools.Link do
  @moduledoc """
  This module provides useful utilities for making links supporting the markdown module
  - book(person) - adoc link to person's page in the book
  - dev(person) - adoc link to person in CfsJksAs app on gigalixir
  - werelate(person) - adoc link to person in werelate
  - myheritage(person) - adoc link to person in myheritage
  - geni(person) - adoc link to person in geni
  """

  @datapath "static/data/"
  @adocpath "static/temp/"


	@doc """
	given a person, create a hyperlink to that person
	most are 'intermediate' and auto-generated
	Terminations are special and not from this routine
	Primary (C, J, A) are special and not from this module
	"""
	def book(relation) do
    "* "
    <> book_link(relation, "[Book page]")
	end

  def book_link(relation, label) do
    # filename is combo of generation and relation
    filename = relation_to_file_root(relation)

    "https://github.com/sparrell/cfs_ancestors/blob/main/"
		<> "Vol_02_Ships/"
		<> "V2_C5_Ancestors/"
		#<> "V2_C5_G"
		#<> to_string(length(relation))
		#<> "/"
		<> filename
    <> label
		<> "\n"

  end

  def dev(person) do
		"* https://cfsjksas.gigalixirapp.com/person?p="
		<> to_string(person.id)
		<> "[Dev website]\n"
	end

  def werelate(person_p) do
    # print werelate link if present, or TBD if not
    url = Map.get(person_p, :werelate)
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
    url = Map.get(person_p, :myheritage)
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
    url = Map.get(person_p, :geni)
    case url do
      nil ->
      "* Geni TBD\n"
      _ ->
        "* "
        <> url
        <> "[Geni]\n"
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
