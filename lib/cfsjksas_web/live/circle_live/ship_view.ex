defmodule CfsjksasWeb.CircleLive.ShipView do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List people who came on ships

    # get the list of ids of people with ships
    ships = Enum.sort(Cfsjksas.Circle.GetPeople.ship_people())

    {:ok,
     socket
     |> assign(:ships, ships)
    }
  end

end
