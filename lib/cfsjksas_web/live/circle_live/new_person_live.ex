defmodule CfsjksasWeb.CircleLive.NewPersonLive do
  use CfsjksasWeb, :live_view
  alias Cfsjksas.Ancestors.NewPerson

  @impl true
  def mount(_params, _session, socket) do
    new_person = %NewPerson{}
    changeset = NewPerson.base_changeset(new_person, %{})

    {:ok,
     socket
     |> assign(:new_person, new_person)
     |> assign(:current_step, 1)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"new_person" => params}, socket) do
IO.inspect(params, label: "params")
    changeset =
      case socket.assigns.current_step do
        1 -> NewPerson.step1_changeset(socket.assigns.new_person, params)
        2 -> NewPerson.step2_changeset(socket.assigns.new_person, params)
        3 -> NewPerson.step3_changeset(socket.assigns.new_person, params)
        _ -> NewPerson.base_changeset(socket.assigns.new_person, params)
      end
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("prev_step", _params, socket) do
    {:noreply, assign(socket, :current_step, max(socket.assigns.current_step - 1, 1))}
  end

  @impl true
  def handle_event("next_step", %{"new_person" => params}, socket) do
    case params["action"] do
      "next"   -> do_next_step(params, socket)
      "finish" -> do_finish(params, socket)
    end
  end

  defp do_next_step(params, socket) do
    current_step = socket.assigns.current_step

    changeset =
      case current_step do
        1 -> NewPerson.step1_changeset(socket.assigns.new_person, params)
        2 -> NewPerson.step2_changeset(socket.assigns.new_person, params)
        3 -> NewPerson.step3_changeset(socket.assigns.new_person, params)
        _ -> NewPerson.base_changeset(socket.assigns.new_person, params)
      end

      IO.inspect(changeset, label: "changeset")

    if changeset.valid? do
IO.inspect("changeset valid")
      {:noreply,
       socket
       |> assign(:new_person, Ecto.Changeset.apply_changes(changeset))
       |> assign(:current_step, current_step + 1)
       |> assign(:changeset, changeset)
       |> assign(:form, to_form(changeset))}
    else
IO.inspect("changeset INvalid")
      {:noreply,
       socket
       |> assign(:changeset, changeset)
       |> assign(:form, to_form(changeset))}
    end
  end

  defp do_finish(params, socket) do
    changeset = NewPerson.full_changeset(socket.assigns.new_person, params)

    if changeset.valid? do
      new_person = Ecto.Changeset.apply_changes(changeset)
IO.inspect(new_person, label: "save changeset")
      # Here you would create the real User + Profile records, etc.
      {:noreply,
       socket
       |> put_flash(:info, "new_person complete")
       |> push_navigate(to: ~p"/")}
    else
      {:noreply,
       socket
       |> assign(:changeset, changeset)
       |> assign(:form, to_form(changeset))}
    end
  end
end
