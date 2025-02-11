defmodule CfsjksasWeb.CircleLive.Surnames do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List people who came on ships

    # get the list of ids of people with ships
    surnames = Cfsjksas.Circle.GetPeople.surnames()

    {:ok,
     socket
     |> assign(:surnames, surnames)
    }
  end

end
