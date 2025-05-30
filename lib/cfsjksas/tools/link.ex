defmodule Cfsjksas.Tools.Link do
  @moduledoc """
  This module provides useful utilities for making links supporting the markdown module
  - book(person) - adoc link to person's page in the book
  - dev(person) - adoc link to person in CfsJksAs app on gigalixir
  - werelate(person) - adoc link to person in werelate
  - myheritage(person) - adoc link to person in myheritage
  - geni(person) - adoc link to person in geni
  - make_filename(person) - used by book but also by markdown.ex (ie filename to store)
  """


	@doc """
	given a person, create a hyperlink to that person
	most are 'intermediate' and auto-generated
	Terminations are special and not from this routine
	Primary (C, J, A) are special and not from this module
	"""
	def book(person) do
		filename = make_filename(person)
		gen = length(person.relation)
		"* https://github.com/spoarrell/cfs_ancestors/tree/main/"
		<> "Vol_02_Ships/"
		<> "V2_C5_Ancestors/"
		<> "V2_C5_G"
		<> to_string(gen)
		<> "/"
		<> filename
		<> "[Book page]\n"
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

  def make_filename(person_r) do
		# filename for 'intermediate' people is combo of generation and relation
		"gen"
		<> to_string(length(person_r.relation)) # length is generation
		<> "."
		<> Enum.join(person_r.relation)
		<> ".adoc"
	end





end
