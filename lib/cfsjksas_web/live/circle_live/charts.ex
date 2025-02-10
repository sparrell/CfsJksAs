defmodule CfsjksasWeb.CircleLive.Charts do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # charts

    #what needed?
    what = :ok
    {:ok,
     socket
     |> assign(:what, what)
    }
  end

end
