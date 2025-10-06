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

    person = Cfsjksas.Ancestors.AgentStores.get_person_a(person_of_interest)
    person_txt = Cfsjksas.Circle.Geprint.print_person(person)

    surname = to_string(person.surname)
    given_name = to_string(person.given_name)

    father =  case person.father do
      nil -> ""
      _ -> to_string(person.father)
    end
    mother =  case person.mother do
      nil -> ""
      _ -> to_string(person.mother)
   end

    get_urls? = Map.has_key?(person, :links)
    pre_urls = case get_urls? do
      false ->
        []
      true ->
        person.links
        |> Map.to_list()
        |> Enum.sort()
    end
    book_url = Cfsjksas.Tools.Link.book_link(person.id, "")
    dev_url = Cfsjksas.Tools.Link.dev_link(person.id)
    urls = [{:book, book_url}, {:dev, dev_url}] ++ pre_urls

    IO.inspect(urls)
    IO.inspect(book_url)
    IO.inspect(dev_url)


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
