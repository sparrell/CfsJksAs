defmodule CfsjksasWeb.CircleLive.IntermediateView do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List intermediate people

    # get the list of ids of people with ships
    intermediates = Enum.sort(Cfsjksas.Ancestors.Person.intermediate_people())
    quantity = length(intermediates)

    {:ok,
     socket
     |> assign(:intermediates, intermediates)
     |> assign(:quantity, quantity)
    }
  end

end
