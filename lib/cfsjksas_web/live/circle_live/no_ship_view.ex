defmodule CfsjksasWeb.CircleLive.NoShipView do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List people who came on ships but we don't know the ship

    # get the list of ids of people with ships
    noships = Enum.sort(Cfsjksas.Circle.GetPeople.no_ship_people())

    {:ok,
     socket
     |> assign(:noships, noships)
    }
  end

end
