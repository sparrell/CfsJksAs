defmodule CfsjksasWeb.CircleLive.BrickWalls do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List brickwalls - line terminating before reaching immigration

    # get the list of ids of people with ships
    brickwalls = Enum.sort(Cfsjksas.Ancestors.Person.brick_walls(),fn({x,_,_,_,_},{y,_,_,_,_}) -> Enum.sum(x) >= Enum.sum(y) end )
    quantity = length(brickwalls)

    {:ok,
     socket
     |> assign(:brickwalls, brickwalls)
     |> assign(:quantity, quantity)
    }
  end

end
