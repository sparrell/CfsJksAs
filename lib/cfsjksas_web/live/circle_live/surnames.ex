defmodule CfsjksasWeb.CircleLive.Surnames do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # List people who came on ships

    # get the list of ids of people with ships
    {surnames, _quanity_unknown_surnames} = Cfsjksas.Ancestors.Person.surnames()
    quanity = length(surnames)

    {:ok,
     socket
     |> assign(:surnames, surnames)
     |> assign(:quanity, quanity)
    }
  end

end
