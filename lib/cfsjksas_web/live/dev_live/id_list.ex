defmodule CfsjksasWeb.DevLive.IdList do
    use CfsjksasWeb, :live_view
    alias Cfsjksas.Ancestors.AgentStores

  @impl true
  @doc """
    everyone sorted by ida
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
  end

  def make_outlist(outlist, [next_id | rest]) do
    name_dates = AgentStores.get_person_a(next_id)
    |> Cfsjksas.Ancestors.Person.get_name_dates()

    outlist ++ [{next_id, name_dates}]
    |> make_outlist(rest)
  end


end
