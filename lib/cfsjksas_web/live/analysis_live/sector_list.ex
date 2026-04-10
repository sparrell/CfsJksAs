defmodule CfsjksasWeb.AnalysisLive.SectorList do
    use CfsjksasWeb, :live_view
    alias Cfsjksas.Ancestors.AgentStores

  @impl true
  @doc """
    everyone sorted by generation/sector
    note people appear multiple times
  """
  def mount(_params, _session, socket) do
    all_id_s_s = AgentStores.get_all_sector_ids()
    quantity = length(all_id_s_s)
    outlist = make_outlist([], all_id_s_s)
    {:ok,
     socket
     |> assign(:all_id_s_s, all_id_s_s)
     |> assign(:quantity, quantity)
     |> assign(:outlist, outlist)
    }
  end

  defp make_outlist(outlist, []) do
    # done
    outlist
    |> Enum.sort()
  end

  defp make_outlist(outlist, [this_id | rest]) do
    {gen, _quad, sector} = this_id
    person_s = AgentStores.get_person_s(this_id)
    person_a = AgentStores.get_person_a(person_s.id_a)
    name_dates = Cfsjksas.Ancestors.Person.get_name_dates(person_a)

    outlist ++ [{gen,
                sector,
                name_dates,
                person_s.id_a
                }]
    |> make_outlist(rest)
  end

end
