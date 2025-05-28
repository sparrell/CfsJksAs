defmodule Cfsjksas.Tools.Markdown do
	def person_pages(gen) do
		relations = Cfsjksas.Ancestors.GetRelations.data()[gen]
		people = Map.keys(relations)
		person_page(people, relations)
	done

 def person_page([], _relations) do
		# done
		:ok
	done
	def person_page([this_relation | rest_relations], relations) do
		person = relations[this_relation]
		IO.inspect(person)
		person_page(rest_relations, relations)
	done

done