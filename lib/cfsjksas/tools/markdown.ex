defmodule Cfsjksas.Tools.Markdown do

	require IEx

	def person_pages(:all) do
		Enum.each(0..14, fn gen -> person_pages(gen) end)
	end

	def person_pages(gen) do

		marked_lineages = Cfsjksas.Chart.AgentStores.get_marked_lineages()
		this_gen_keys = Cfsjksas.Chart.AgentStores.m_ids_by_gen(gen)
		person_page(this_gen_keys, gen, marked_lineages)
	end

	def person_page([], gen, _marked_lineages) do
		# done
		IO.inspect(gen, label: "finished")
	end
	def person_page([this_id_l | rest_id_ls], gen, marked_lineages) do
IO.inspect(this_id_l, label: "person page this_relation")
IEx.pry()
# redo this next stuff using label for filepath
		person_l = marked_lineages[this_id_l]
		person_a = Cfsjksas.Chart.AgentStores.get_person_a(person_l.id)

		this_relation = person_l.relation

		filepath = Cfsjksas.Tools.Link.make_filename(this_relation, :adoc)

		check_facts(person_l.id)

		"= "
		<> make_title(person_a)
		<> make_narrative(this_relation)
		<> "\n== Vital Stats\n"
		<> make_vitals(person_a)
		<> make_ship(person_a, Map.has_key?(person_a, :ship))
		<> make_no_ship(person_a, Map.has_key?(person_a, :no_ship))
		<> "\n== Family\n"
		<> make_family(person_l, gen, marked_lineages)
		<> "\n== Reference Links\n"
		<> make_refs(person_a,this_relation)
		<> "\n== Relations\n"
		<> make_relations(person_a)
		<> "\n== Other\n"
		<> make_other(person_a)
		<> "\n== Sources\n"
		<> make_sources(person_a)
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

		IO.inspect(this_relation, label: "wrote")

		# recurse thru rest
		person_page(rest_id_ls, gen, marked_lineages)
	end

	def get_dates(person) do
		person.birth_year
		<> " - "
		<> person.death_year
	end


	def make_label(id_a) do
		IO.inspect("need to fix make_label")
		person_a = Cfsjksas.Chart.AgentStores.get_person_a(id_a)
		name = person_a.label <> "_(" <> person_a.birth_year <> "_-_" <> person_a.death_year <> ")"
	end

	def make_title(person) do
		Cfsjksas.Ancestors.Person.get_name(person)
		<> " ("
		<> get_dates(person)
		<> ")"
	end

	@doc """
	print narrative (in markdown?)
	"""
	def make_narrative(relation) do
		# check if narritive file exists
		filepath = Cfsjksas.Tools.Link.make_filename(relation, :md)
		{:ok, md} = case File.exists?(filepath) do
			true ->
				File.read(filepath)
			false ->
				{:ok, "\n\nNarrative TBD\n\n"}
		end

		# return markdown text
		md

	end

	def make_vitals(person_r) do
		person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)
		"\n\n"
		<> not_nil("Sex: ", person_p.sex)
		<> not_nil("Married Name: ", person_p.married_name)
		<> not_nil("Also known as: ", person_p.also_known_as)
		<> not_nil("Birth: ", person_p.birth_date)
		<> not_nil("Birthplace: ", person_p.birth_place)
		<> not_nil("Birth note: ", person_p.birth_note)
		<> not_nil("Birth source: ", person_p.birth_source)
		<> not_nil("Baptism: ", person_p.baptism)
		<> not_nil("Christening: ", person_p.christening)
		<> not_nil("Death: ", person_p.death_date)
		<> not_nil("Deathplace: ", person_p.death_place)
		<> not_nil("Death note: ", person_p.death_note)
		<> not_nil("Buried: ", person_p.buried)
		<> not_nil("Age at Death: ", person_p.death_age)
		<> not_nil("Death Cause: ", person_p.death_cause)
		<> not_nil("Death Source: ", person_p.death_source)
		<> "\n"

	end

	def make_refs(person_r, relation) do
		person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)
		Cfsjksas.Tools.Link.book(relation)
		<> Cfsjksas.Tools.Link.wikipedia(person_p)
		<> Cfsjksas.Tools.Link.dev(person_r)
		<> Cfsjksas.Tools.Link.werelate(person_p)
		<> Cfsjksas.Tools.Link.myheritage(person_p)
		<> Cfsjksas.Tools.Link.geni(person_p)
		<> Cfsjksas.Tools.Link.wikitree(person_p)
	end

	def make_family(person_r, gen, relations) do
		person_a = Cfsjksas.Chart.AgentStores.get_person_a(person_r.id)
		mom_id = person_a.mother
		mom_text = cond do
			(mom_id == nil) and (person_a.ship != nil) ->
				# person in immigrant so Mom is out of scope
				"immigrant so Mom is NA"
			mom_id == nil ->
				# person is not immigrant, and don't have mother so she is brickwall
				"brickwall"
			true ->
				# return labeled link
				Cfsjksas.Tools.Link.book_link(:xxx, mom_id)
				<> "\n"
			end

			dad_id = person_a.father
			dad_text = cond do
				(dad_id == nil) and (person_a.ship != nil) ->
					# person in immigrant so Mom is out of scope
					"immigrant so Dad is NA"
				dad_id == nil ->
					# person is not immigrant, and don't have father so she is brickwall
					"brickwall"
				true ->
					# return labeled link
					Cfsjksas.Tools.Link.book_link(:xxx, dad_id)
					<> "\n"
			end

		child_text = case gen do
			# special case for gen 1
			1 ->
				"CFS/JKS/AS"
			_ ->
				# to get the child in this line, take off the last P or M in the relation
				child_relation = List.delete_at(person_r.relation, -1)
				# find the id_a of the child
				child_id_a = Cfsjksas.Chart.AgentStores.get_person_r(child_relation).id_a
				# return labeled link
				Cfsjksas.Tools.Link.book_link(:xxx, child_id_a)
					<> "\n"
		end

		"* Mother: "
		<> mom_text
		<> "\n* Father: "
		<> dad_text
		<> "\n"
		<> "* Child*: "
		<> child_text
		<> "\n"
	end

	def make_relations(person_r) do
		# loop thru the sorted lineages
		person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)
		# number the lineages
		make_relations("", person_p.relation_list, 1)
	end
	@doc """
	make_relations(text, list_of_relation_lists, lineage_numb, relations)
	recurse thru the lisf of relation lists, making linkeage text for each
	"""
	def make_relations(text, [], _lineage_numb) do
		# no lineages left so done
		text
	end
	def make_relations(text, [this_list | rest_of_lists], lineage_numb) do
		# start with previous text, add header of lineage number, and add lineage
		text
		<> "=== Lineage \#"
		<> to_string(lineage_numb)
		<> "\n"
		<> make_lineage(this_list)
		|> make_relations(rest_of_lists, lineage_numb + 1)
	end

	@doc """
	the relations list is a list of "P" and "M" of length gen
	  (ie one for each generation)
	make_lineage/1 calls make_lineage/3 to create the markdown
	for each person in the lineage

	Special case: note if the relastions are for a duplicate,
	then the final link will be different.
	quick fix is to not put in link for any 'final' person
	since you are on that page anyway
	"""

	def make_lineage(relation) do
		# walk thru list of relations left to right adding links
		init_text = "* https://github.com/spoarrell/cfs_ancestors/tree/main/"
		<> "Vol_02_Ships/V2_C1_Principals/0_intro_principals.adoc[Charles, James, Ann Sparrell]\n"

		# to avoid link for final person, stip off last relation
		# and add final person without link
		mod_r_list = List.delete_at(relation, -1)
		gen = length(relation)
		person = Cfsjksas.Ancestors.GetLineages.person(gen, relation)
		if person == nil do
			IEx.pry()
		end

		make_lineage(init_text, [], mod_r_list)
		<> "* " <> make_label(person.id) <> "\n\n"
	end
	@doc """
	make_lineage(person_r, text, done, todo, gen, relations)
	text is the asciiidoc as it evolved
	done are the items in the relations list already done (ie have links)
	todo are the items yet to  create the link for those people in the lineage
	gen generations (helper)
	relations (helper)
	"""
	def make_lineage(text, _done, []) do
		# todo is empty so done
		text
	end
	def make_lineage(text, done, [this | rest]) do
		# the relation key for "this" person is done + this
		this_relation = done ++ [this]
		gen = length(this_relation)
		this_person = Cfsjksas.Ancestors.GetLineages.person(gen, this_relation)
		label = "[" <> make_label(this_person.id) <> "]"
		new_text = text <> "* " <> Cfsjksas.Tools.Link.book_link(this_relation, label) <> "\n"
		new_done = done ++ [this]
		# recurse thru rest
		make_lineage(new_text, new_done, rest)
	end

	def make_ship(_person_r, false) do
		# not an immigrant so leave off ship markdown
		""
	end
	def make_ship(person_r, true) do
		# immigrgant whose ship is known
		IEx.pry()
		"\n== Ship\n"
	end
	def make_no_ship(_person_r, false) do
		# not an immigrant so leave off no_ship markdown
		""
	end
	def make_no_ship(person_r, true) do
		# immigrgant whose ship is unknown
		IEx.pry()
		"\n== No Ship\n"

	end

	def make_other(person_r) do
		person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)
		keys = Cfsjksas.Hybrid.Get.other()
		make_other("", keys, person_p)
	end
	def make_other(text, [], _person_p) do
	  # no keys left so done
	  text
	end
	def make_other(text, [key | rest], person_p) do
		case {Map.has_key?(person_p, key), Map.get(person_p, key)} do
			{true, nil} ->
				text
			{true, []} ->
				text
			{true, value} when is_list(value) ->
				text
				<> to_string(key)
				<> ": "
				<> unlist(value)
				<> "\n"
			{true, value} when is_binary(value) ->
				text
				<> to_string(key)
				<> ": "
				<> linify(value)
				<> "\n"
			{false, value} ->
				# shouldn't get here. no key?
				IO.inspect({key, value}, label: "error")
				IEx.pry()
		end
		|> make_other(rest, person_p)
	end

	def unlist(value) do
		# value is a list, break into items, noe per linse
	  unlist("", value)
	end
	def unlist(text, []) do
	  # list is empty so done
	  text
	end
	def unlist(text, [this | rest]) do
	  text
	  <> linify(this)
	  |> unlist(rest)
	end


	def make_sources(person_r) do
		person_p = Cfsjksas.Ancestors.GetAncestors.person(person_r.id)

		case Map.get(person_p, :sources) do
			nil ->
				""
			_ ->
				make_sources("", person_p.sources)
		end
	end

	def make_sources(markdown, []) do
		# done
		markdown
	end
	def make_sources(markdown, [this | rest]) do
		markdown
		<> "* " <> linify(this) <> "\n"
		# recurse thru rest
		|> make_sources(rest)
	end

	def not_nil(_label, nil) do
		""
	end
	def not_nil(_label, []) do
		""
	end
	def not_nil(label, value) do
		"* "
		<> label
		<> linify(to_string(value))
		<> "\n"
	end

	def linify(text) do
		[h | t] = String.split(text, "\n", parts: 2)
		h
		<> case t do
			[] ->
				""
			_ ->
				"\n----\n" <> List.first(t) <> "\n----\n"
		end
	end

	@doc """
	helper to see if missed any facts
	get list of all keys for person
	check what keys have non-nil or non-empty-list values
	that are not already printing
	"""
	def check_facts(person_id) do
		# keys already covered
		already = Cfsjksas.Chart.GetCircle.already()

		person = Cfsjksas.Chart.AgentStores.get_person_a(person_id)

		Map.keys(person) -- already
		|> check_facts(person)
	end

	@doc """
	iterate thru list of keys checking for non-nil, non-emply list
	"""
	def check_facts([], _person) do
		# none left to check
		nil
	end
	def check_facts([this | rest], person) do
		case person[this] do
			nil ->
				nil
			[] ->
				nil
			_ ->
				IO.inspect(this, label: "key")
				IO.inspect(person, label: "person")
				IEx.pry()
		end
	end


end
