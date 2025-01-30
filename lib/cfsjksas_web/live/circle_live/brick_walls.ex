defmodule CfsjksasWeb.CircleLive.BrickWalls do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List brickwalls - line terminating before reaching immigration

    # get the list of ids of people with ships
    brickwalls = Enum.sort(Cfsjksas.Circle.GetPeople.brick_walls())

    {:ok,
     socket
     |> assign(:brickwalls, brickwalls)
    }
  end

end
