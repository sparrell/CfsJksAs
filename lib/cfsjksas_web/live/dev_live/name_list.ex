defmodule CfsjksasWeb.DevLive.NameList do
    use CfsjksasWeb, :live_view
    alias Cfsjksas.Ancestors.AgentStores

  @impl true
  @doc """
    everyone sorted by last name, first name, birth_year, death_year
  """
  def mount(_params, _session, socket) do
    all_id_a_s = AgentStores.all_a_ids() |> Enum.sort()
    quantity = length(all_id_a_s)
    outlist = make_outlist([], all_id_a_s)
    {:ok,
     socket
     |> assign(:all_id_a_s, all_id_a_s)
     |> assign(:quantity, quantity)
     |> assign(:outlist, outlist)
    }
  end

  def make_outlist(outlist, []) do
    # done
    outlist
    |> Enum.sort()
  end

  def make_outlist(outlist, [this_id | rest]) do
    person =AgentStores.get_person_a(this_id)
    name_dates = Cfsjksas.Ancestors.Person.get_name_dates(person)

    outlist ++ [{person.surname,
                person.given_name,
                person.birth_date,
                person.death_date,
                name_dates,
                this_id}]
    |> make_outlist(rest)
  end


end
