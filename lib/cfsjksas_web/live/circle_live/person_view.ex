defmodule CfsjksasWeb.CircleLive.PersonView do
  use CfsjksasWeb, :live_view

  require IEx

  @impl true
  def mount(params, _session, socket) do
    # show info for a person

    # default to CFS if no parameter for another person
    person_of_interest = if Map.has_key?(params, "p") do
      String.to_existing_atom(params["p"])
    else
      :p0005
    end

    person = Cfsjksas.Ancestors.GetAncestors.person(person_of_interest)
    person_txt = Cfsjksas.Circle.Geprint.print_person(person)

    surname = to_string(person.surname)
    given_name = to_string(person.given_name)

    # take random (first) relation to find father and mother
    [relation | _rest ] = person.relation_list
    gen = Cfsjksas.Ancestors.Lineage.gen_from_relation(relation)
    father_result = Cfsjksas.Ancestors.Lineage.father(gen, relation)
    father =  case father_result do
      nil -> ""
      _ -> to_string(father_result)
    end
    mother_result = Cfsjksas.Ancestors.Lineage.mother(gen, relation)
    mother =  case mother_result do
      nil -> ""
      _ -> to_string(mother_result)
    end
    get_urls? = Map.has_key?(person, :urls)
    urls = case get_urls? do
      false -> []
      true -> Map.to_list(person.urls)
    end

    {:ok,
     socket
     |> assign(:person_of_interest, to_string(person_of_interest))
     |> assign(:person, person)
     |> assign(:person_txt, person_txt)
     |> assign(:surname, surname)
     |> assign(:given_name, given_name)
     |> assign(:father, father)
     |> assign(:mother, mother)
     |> assign(:urls, urls)
    }
  end

end
