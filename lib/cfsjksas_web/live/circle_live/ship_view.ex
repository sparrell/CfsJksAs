defmodule CfsjksasWeb.CircleLive.ShipView do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List people who came on ships

    # get the list of ids of people with ships
    ships = Enum.sort(Cfsjksas.Ancestors.Person.ship_people())
    quantity = length(ships)

    {:ok,
     socket
     |> assign(:ships, ships)
     |> assign(:quantity, quantity)
    }
  end

end
