defmodule CfsjksasWeb.CircleLive.AddPerson do
  use CfsjksasWeb, :live_view

  require IEx

  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "people2_ex.txt"])
  @unused_atoms [:p9950, :p9951, :p9952, :p9953, :p9954, :p9955, :p9956, :p9957, :p9958, :p9959,
                 :p9960, :p9961, :p9962, :p9963, :p9964, :p9965, :p9966, :p9967, :p9968, :p9969,
                 :p9970, :p9971,
                ]
  @person_form %{
      "given_name" => "given_name",
      "surname" => "surname",
      "gender" => "male",
      "birth_date" => "birth_date",
      "birth_year" => "birth_year",
      "birth_place" => "birth_place",
      "death_date" => "death_date",
      "death_year" => "death_year",
      "death_place" => "death_place",
      "description" => "",           # free text
      "id_a" => :to_be_computed,
      "father" => :tbd,
      "mother" => :tbd,
      "child" => :to_be_computed,
  }


  @impl true
  def mount(params, _session, socket) do
    person_id_txt = Map.get(params, "p")

    {:ok, get_assigns(socket, person_id_txt)}
  end

  @impl true
  def handle_event("validate", %{"entry" => params}, socket) do
    {:noreply, assign(socket, :form_entry, Map.merge(socket.assigns.form_entry, params))}
  end

  @impl true
  def handle_event("save", %{"entry" => params}, socket) do
    person_id = params["person_id"]
    entry = Map.delete(params, "person_id")

    new_map = Map.put(socket.assigns.person_map, person_id, entry)
    socket =
      socket
      |> assign(:person_map, new_map)
      |> assign(:form_entry, @person_form)

    {:noreply, socket}
  end

  def get_assigns(socket, nil) do
    # no person present so return mostly empty
    # with flag set for error message to display
    socket
    |> assign(:person, nil)
    |> assign(:error_message, "You need to enter a person parameter on URL, e.g. ?p=:p1234")
    |> assign(:show_form?, false)
  end
  def get_assigns(socket, person_id_txt) do
    people = @data_path |> Code.eval_file() |> elem(0)
    people_ids = Map.keys(people)
    unused_atoms = @unused_atoms
    {id_status, id_answer} = to_existing(person_id_txt)
    # check if person_id is (1) already used (2) an unused atom (3) neither
    id_ok = cond do
      id_answer in people_ids ->
        :used
      id_answer in unused_atoms ->
        :unused
      true ->
        :malformed
    end
    check_id(socket, id_status, id_answer, id_ok)
  end

  defp check_id(socket, :error, error_msg, _id_ok) do
    socket
    |> assign(:person, nil)
    |> assign(:error_message, error_msg)
    |> assign(:show_form?, false)
  end
  defp check_id(socket, :ok, person_id, :used) do
    socket
    |> assign(:person, person_id)
    |> assign(:error_message, "#{inspect(person_id)} is existing person - use edit not add")
    |> assign(:show_form?, false)
  end
  defp check_id(socket, :ok, person_id, :malformed) do
    socket
    |> assign(:person, person_id)
    |> assign(:error_message, "#{inspect(person_id)} is malformed")
    |> assign(:show_form?, false)
  end
  defp check_id(socket,   :ok, person_id, :unused) do
    # set up the default values for an input form
    person_map = %{person_id => @person_form}

    socket
    |> assign(:person_id, person_id)
    |> assign(:error_message, nil)
    |> assign(:show_form?, true)
    |> assign(:person_map, person_map)
    |> assign(:form_entry, @person_form)
    |> assign(:available_genders, ~w(male female))
  end

  defp to_existing(s) do
    try do
      {:ok, String.to_existing_atom(s)}
    rescue
      ArgumentError ->
        {:error, "invalid id: #{inspect(s)}"}
    end
  end


end
