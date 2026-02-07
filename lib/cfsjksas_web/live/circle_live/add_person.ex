defmodule CfsjksasWeb.CircleLive.AddPerson do
  use CfsjksasWeb, :live_view

  require IEx

  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "people2_ex.txt"])
  @unused_atoms [:p9950, :p9951, :p9952, :p9953, :p9954, :p9955, :p9956, :p9957, :p9958, :p9959,
                 :p9960, :p9961, :p9962, :p9963, :p9964, :p9965, :p9966, :p9967, :p9968, :p9969,
                 :p9970, :p9971,
                ]
  @person_form %{
      "given_name" => "",
      "surname" => "",
      "gender" => "",
      "birth_date" => "",
      "birth_year" => "",
      "birth_place" => "",
      "death_date" => "",
      "death_year" => "",
      "death_place" => "",
      "description" => "",
      "father" => "",
      "mother" => "",
  }
  @p1_keys [
    :id,
    :label,
    :given_name,
    :surname,
    :also_known_as,
    :birth_date,
    :birth_year,
    :birth_place,
    :baptism,
    :death_date,
    :death_year,
    :death_place,
    :sex,
    :father,
    :mother,
    :event,
    :description,
    :notes,
  ]
  @p2_keys [
    :name_prefix,
    :upd,
    :will,
    :rin,
    :birth_note,
    :naturalized,
    :sources,
    :death_age,
    :religion,
    :title,
    :mh_fams,
    :married_name,
    :graduation,
    :death_source,
    :name_suffix,
    :birth_source,
    :nickname,
    :family_of_origin,
    :mh_famc,
    :residence,
    :occupation,
    :mh_name,
    :christening,
    :death_cause,
    :uid,
    :immigration,
    :buried,
    :former_name,
    :mh_famc2,
    :census,
    :mh_id,
    :death_note,
    :ordained,
    :education,
    :family_of_procreation,
    :emigration,
    :probate,
  ]


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
IO.inspect(params, label: "params") # rm.
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
    |> assign(:person_id, nil)
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
    |> assign(:person_id, nil)
    |> assign(:error_message, error_msg)
    |> assign(:show_form?, false)
  end
  defp check_id(socket, :ok, person_id, :used) do
    # grap person_a from people2 and add map to assigns
    # so then can loop thru all in the 'error' message (make non-eror and it's own clause)
    people = @data_path |> Code.eval_file() |> elem(0)
    person_a = people[person_id]
    # get intersection of keys that exist and list of desired
    p1keys = Enum.filter(@p1_keys, &Enum.member?(Map.keys(person_a), &1))
    p2keys = Enum.filter(@p2_keys, &Enum.member?(Map.keys(person_a), &1))

    socket
    |> assign(:person_id, person_id)
    |> assign(:error_message, "#{inspect(person_id)} is existing person - use edit not add")
    |> assign(:show_form?, false)
    |> assign(:show_used?, true)
    |> assign(:person_a, person_a)
    |> assign(:p1keys, p1keys)
    |> assign(:p2keys, p2keys)
  end
  defp check_id(socket, :ok, person_id, :malformed) do
    socket
    |> assign(:person, person_id)
    |> assign(:error_message, "#{inspect(person_id)} is malformed")
    |> assign(:show_form?, false)
  end
  defp check_id(socket,   :ok, person_id, :unused) do
    # set up the default values for an input form
IO.inspect(socket.assigns, label: "socket.assigns") # rm.
    person_map = %{person_id => @person_form}

    socket
    |> assign(:person_id, person_id)
    |> assign(:error_message, nil)
    |> assign(:show_form?, true)
    |> assign(:person_map, person_map)
    |> assign(:form_entry, @person_form)
    |> assign(:available_genders, ~w(pick male female))
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
