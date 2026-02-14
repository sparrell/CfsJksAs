defmodule CfsjksasWeb.CircleLive.SignupLive do
  use CfsjksasWeb, :live_view
  alias Cfsjksas.Ancestors.Signup

  @impl true
  def mount(_params, _session, socket) do
    signup = %Signup{}
    changeset = Signup.base_changeset(signup, %{})

    {:ok,
     socket
     |> assign(:signup, signup)
     |> assign(:current_step, 1)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"signup" => params}, socket) do
IO.inspect(params, label: "params")
    changeset =
      case socket.assigns.current_step do
        1 -> Signup.step1_changeset(socket.assigns.signup, params)
        2 -> Signup.step2_changeset(socket.assigns.signup, params)
        3 -> Signup.step3_changeset(socket.assigns.signup, params)
        _ -> Signup.base_changeset(socket.assigns.signup, params)
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
  def handle_event("next_step", %{"signup" => params}, socket) do
    case params["action"] do
      "next"   -> do_next_step(params, socket)
      "finish" -> do_finish(params, socket)
    end
  end

  defp do_next_step(params, socket) do
    current_step = socket.assigns.current_step

    changeset =
      case current_step do
        1 -> Signup.step1_changeset(socket.assigns.signup, params)
        2 -> Signup.step2_changeset(socket.assigns.signup, params)
        3 -> Signup.step3_changeset(socket.assigns.signup, params)
        _ -> Signup.base_changeset(socket.assigns.signup, params)
      end

      IO.inspect(changeset, label: "changeset")

    if changeset.valid? do
IO.inspect("changeset valid")
      {:noreply,
       socket
       |> assign(:signup, Ecto.Changeset.apply_changes(changeset))
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
    changeset = Signup.full_changeset(socket.assigns.signup, params)

    if changeset.valid? do
      signup = Ecto.Changeset.apply_changes(changeset)
IO.inspect(signup, label: "save changeset")
      # Here you would create the real User + Profile records, etc.
      {:noreply,
       socket
       |> put_flash(:info, "Signup complete")
       |> push_navigate(to: ~p"/")}
    else
      {:noreply,
       socket
       |> assign(:changeset, changeset)
       |> assign(:form, to_form(changeset))}
    end
  end
end
