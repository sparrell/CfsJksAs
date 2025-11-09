defmodule CfsjksasWeb.CircleLive.AdocView do
  use CfsjksasWeb, :live_view

  require IEx

  @impl true
  def mount(params, _session, socket) do
    # show info for a person (the html of the adoc)

    # default to CFS if no parameter for another person
    person_of_interest = if Map.has_key?(params, "p") do
      String.to_existing_atom(params["p"])
    else
      :p0486
    end

    person_a = Cfsjksas.Ancestors.AgentStores.get_person_a(person_of_interest)
    adoc_html_path = Path.join("priv/static/adoc_html", "#{person_a.label}.html")
    adoc_html_file_txt = File.read!(adoc_html_path)

    {:ok,
     socket
     |> assign(:adoc_html_file_txt, adoc_html_file_txt)
    }
  end

end
