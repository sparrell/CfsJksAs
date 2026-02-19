defmodule CfsjksasWeb.EntryLive.AddPersonLive do
  use CfsjksasWeb, :live_view
  alias Cfsjksas.Ancestors.AddPerson

  @unused_atoms [:p9950, :p9951, :p9952, :p9953, :p9954, :p9955, :p9956, :p9957, :p9958, :p9959,
                 :p9960, :p9961, :p9962, :p9963, :p9964, :p9965, :p9966, :p9967, :p9968, :p9969,
                 :p9970, :p9971,
                ]
  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "people2_ex.txt"])


  @impl true
  def mount(_params, _session, socket) do
    new_person = %AddPerson{}
    changeset = AddPerson.base_changeset(new_person, %{})

    {:ok,
     socket
     |> assign(:new_person, new_person)
     |> assign(:problem?, false) # initialize no errors
     |> assign(:error_message, "")
     |> assign(:already?, false) # initialize not already
     |> assign(:current_step, 1)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"add_person" => params}, socket) do
IO.inspect(params, label: "params")
    changeset =
      case socket.assigns.current_step do
        1 -> AddPerson.step1_id_changeset(socket.assigns.new_person, params)
        2 -> AddPerson.step2_name_changeset(socket.assigns.new_person, params)
        3 -> AddPerson.step3_gender_changeset(socket.assigns.new_person, params)
        _ -> AddPerson.base_changeset(socket.assigns.new_person, params)
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
  def handle_event("next_step", %{"add_person" => params}, socket) do
    case params["action"] do
      "id"     -> do_id(params, socket)
      "next"   -> do_next_step(params, socket)
      "finish" -> do_finish(params, socket)
    end
  end

  defp do_id(params, socket) do
IO.inspect(params, label: "do_id params") # rm.
    changeset = AddPerson.step1_id_changeset(socket.assigns.new_person, params)
IO.inspect(changeset, label: "do_id changeset") # rm.
    # check id is used, unused, or invalid
    id = params["id"]
IO.inspect(id, label: "do_id id") # rm.
    {id_status, id_answer, id_ok} = check_id(id)
IO.inspect({id_status, id_answer, id_ok} , label: "{id_status, id_answer, id_ok} ") # rm.
    # check for errors, used id, unused id and return accordingly
    cond do
      not changeset.valid? ->
IO.inspect("id changeset INVALID")
        {:noreply,
        socket
          |> assign(:problem?, true)
          |> assign(:error_message, "invalid id")
          |> assign(:changeset, changeset)
          |> assign(:form, to_form(changeset))}

      id_status == :error ->
IO.inspect("id to atom error")
        {:noreply,
          socket
          |> assign(:problem?, true)
          |> assign(:error_message, id_answer)
          |> assign(:changeset, changeset)
          |> assign(:form, to_form(changeset))}

      id_ok == :bad_id ->
IO.inspect("bad id")
        {:noreply,
          socket
          |> assign(:problem?, true)
          |> assign(:error_message, "bad id")
          |> assign(:changeset, changeset)
          |> assign(:form, to_form(changeset))}

      id_ok == :used ->
        people = @data_path |> Code.eval_file() |> elem(0)
        person = people[id_answer]
        person_keys = person |> Map.keys() |> Enum.sort()
        {:noreply,
          socket
          |> assign(:already?, true)
          |> assign(:id, id_answer)
          |> assign(:person, person)
          |> assign(:person_keys, person_keys)
          |> assign(:changeset, changeset)
          |> assign(:form, to_form(changeset))}

      id_ok == :unused ->
IO.inspect("id UNused - need to do more here?")
        {:noreply,
          socket
          |> assign(:new_person, Ecto.Changeset.apply_changes(changeset))
          |> assign(:current_step, socket.assigns.current_step + 1)
          |> assign(:changeset, changeset)
          |> assign(:form, to_form(changeset))}

    end

  end

  defp do_next_step(params, socket) do
    current_step = socket.assigns.current_step

    changeset =
      case current_step do
        1 -> AddPerson.step1_id_changeset(socket.assigns.new_person, params)
        2 -> AddPerson.step2_name_changeset(socket.assigns.new_person, params)
        3 -> AddPerson.step3_gender_changeset(socket.assigns.new_person, params)
        _ -> AddPerson.base_changeset(socket.assigns.new_person, params)
      end

IO.inspect(changeset, label: "changeset") # rm.

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
    changeset = AddPerson.full_changeset(socket.assigns.new_person, params)

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

  defp check_id(id_text) do
    {id_status, id_answer} = to_existing(id_text)
    # check if person_id is (1) already used (2) an unused atom (3) neither
    people = @data_path |> Code.eval_file() |> elem(0)
    people_ids = Map.keys(people)
    unused_atoms = @unused_atoms

    id_ok = cond do
      id_answer in people_ids ->
        :used
      id_answer in unused_atoms ->
        :unused
      true ->
        :bad_id
    end
    {id_status, id_answer, id_ok}
  end

  defp to_existing(s) do
    try do
      {:ok, String.to_existing_atom(s)}
    rescue
      ArgumentError ->
        {:error, "invalid id: #{inspect(s)}"}
    end
  end



  def person_form(assigns) do
    ~H"""
      <%= if @current_step > 1 do %>
        <.button type="button" phx-click="prev_step">Back</.button>
      <% end %>

      <%= cond do %>
      <% @current_step == 1 -> %>
        <p></p>
        <.input field={@form[:id]} label="Ancestor ID" />
        <p></p>
        <.button type="submit" name="add_person[action]" value="id">Continue</.button>
      <% @current_step == 2 -> %>
        <p></p>
        <.input field={@form[:given_name]} label="Given name" />
        <.input field={@form[:surname]} label="Surname" />
        <p></p>
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 3 -> %>
        <p></p>
        <.input field={@form[:gender]} type="select"
          options={[{"Male", :male}, {"Female", :female}]} />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 4 -> %>
        need to do
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% true -> %>
        need to do
        <.button type="submit" name="add_person[action]" value="finish">Finish</.button>

      <% end %>

    """
  end
end
