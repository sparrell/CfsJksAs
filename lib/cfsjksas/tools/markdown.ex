defmodule Cfsjksas.Tools.Markdown do

	require IEx

	def person_pages(gen) do
		relations = Cfsjksas.Ancestors.GetRelations.data()[gen]
		people = Map.keys(relations)
		person_page(people, relations)
	end

	def person_page([], _relations) do
		# done
		IO.inspect("finished")
	end
	def person_page([this_relation | rest_relations], relations) do
		person = relations[this_relation]
		filename = Cfsjksas.Tools.Link.make_filename(person)
		filepath = Path.join(:code.priv_dir(:cfsjksas), "static/temp/" <> filename)

		"= "
		<> make_title(person)
		<> "\n\n"
		<> "TBD narrative goes here\n\n"
		<> "\n== Vital Stats\n"
		<> make_vitals(person)
		<> "\n== Family\n"
		<> make_family(person)
		<> "\n== Reference Links\n"
		<> make_refs(person)
		<> "\n== Relations\n"
		<> make_relations(person)
		<> "\n== Other\n"
		<> make_other(person)
		<> "\n== Sources\n"
		<> make_sources(person)
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

		IO.inspect(filename, label: "wrote")

		# recurse thru rest
		person_page(rest_relations, relations)
	end

	def get_name(person) do
		person.given_name
		<> " "
		<> person.surname
	end

	def get_dates(person) do
		person.birth_year
		<> " - "
		<> person.death_year
	end

	def make_title(person) do
		get_name(person)
		<> " ("
		<> get_dates(person)
		<> ")"
	end

	def make_vitals(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)
		"\n\n"
		<> not_nil("Birth: ", person_p.birth_date)
		<> not_nil("Birthplace: ", person_p.birth_place)
		<> not_nil("Death: ", person_p.death_date)
		<> not_nil("Deathplace: ", person_p.death_place)
		<> not_nil("Buried: ", person_p.buried)
		<> not_nil("Age at Death: ", person_p.death_age)
		<> "\n"

	end

	def make_refs(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)
		Cfsjksas.Tools.Link.book(person_r)
		<> Cfsjksas.Tools.Link.dev(person_r)
		<> Cfsjksas.Tools.Link.werelate(person_p)
		<> Cfsjksas.Tools.Link.myheritage(person_p)
		<> Cfsjksas.Tools.Link.geni(person_p)
	end

	def make_family(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)
		mom = person_r.mother
		"need to fix make_family of "
		<> to_string(person_p.id)
		<> " / mom: "
		<> to_string(mom)
		<> "\n"
	end

	def make_relations(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)
		"need to fix make_relations of "
		<> to_string(person_p.id)
		<> "\n"
	end

	def make_other(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)

		not_nil("Occupation: ", person_p.occupation)
		<> not_nil("Census:", person_p.census)
		<> not_nil("Notes:", person_p.notes)
	end

	def make_sources(person_r) do
		person_p = Cfsjksas.Ancestors.GetPeople.person(person_r.id)

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

end
