defmodule Cfsjksas.Ancestors.AddPerson do
  use Ecto.Schema
  import Ecto.Changeset

  require IEx

  @id_regex ~r/^[a-z][0-9]{4}$/

  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "people2_ex.txt"])


  @primary_key false
  embedded_schema do
    field :id, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :given_name, :string
    field :surname, :string
    field :birth_date, :string, default: "nil"
    field :birth_year, :string, default: "nil"
    field :birth_place, :string, default: "nil"
    field :death_date, :string, default: "nil"
    field :death_year, :string, default: "nil"
    field :death_place, :string, default: "nil"
    field :father, :string, default: "nil"
    field :mother, :string, default: "nil"
    field :ship?, Ecto.Enum, values: [true, false]
    field :ship_name, :string, default: "nil"
    field :ship_date, :string, default: "nil"
    field :label, :string
    field :geni, :string, default: "nil"
    field :myheritage, :string, default: "nil"
    field :werelate, :string, default: "nil"
    field :wikitree, :string, default: "nil"
  end

  # base cast
  def base_changeset(new_person, attrs \\ %{}) do
    new_person
    |> cast(attrs, [:id,
                    :given_name, :surname,
                    :gender,
                    :birth_date, :birth_year, :birth_place,
                    :death_date, :death_year, :death_place,
                    :father, :mother,
                    :ship?, :ship_name, :ship_date,
                    :label,
                    :geni, :myheritage, :werelate, :wikitree,
                    ])
  end

  # validations for step 1 ID
  def step1_id_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:id])
    |> validate_length(:id, is: 5)
    |> validate_format(:id, @id_regex, message: "must be one lowercase letter followed by 4 digits")
  end

  def step2_name_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:given_name, :surname])
    |> validate_length(:given_name, min: 1, message: "given_name must be at least one character")
    |> validate_length(:surname, min: 1, message: "surname must be at least one character")
  end

  def step3_gender_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:gender])
  end

  def step4_birth_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:birth_date, :birth_year, :birth_place])
    |> validate_length(:birth_date, min: 1, message: "birth_date must be at least one character")
    |> validate_length(:birth_year, min: 1, message: "birth_year must be at least one character")
    |> validate_length(:birth_place, min: 1, message: "birth_place must be at least one character")
  end

  def step5_death_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:death_date, :death_year, :death_place])
    |> validate_length(:death_date, min: 1, message: "death_date must be at least one character")
    |> validate_length(:death_year, min: 1, message: "death_year must be at least one character")
    |> validate_length(:death_place, min: 1, message: "death_place must be at least one character")
  end

  def step6_mom_dad_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:mother, :father])
    |> validate_length(:mother, min: 3, message: "mother must be at least three characters")
    |> validate_length(:father, min: 3, message: "father must be at least three characters")
  end

  def step7_ship_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:ship?, :ship_name, :ship_date])
    |> validate_length(:ship_name, min: 1, message: "ship_name must be at least one character - use nil in unknown or na")
    |> validate_length(:ship_date, min: 1, message: "ship_date must be at least one character - use nil in unknown or na")
  end

  def step8_label_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:label])
    |> validate_label(:label)
  end

  def step9_links_changeset(new_person, attrs) do
    new_person
    |> base_changeset(attrs)
    |> validate_required([:geni, :myheritage, :werelate, :wikitree,])
    |> validate_length(:geni, min: 3, message: "geni must be at least three characters")
    |> validate_length(:myheritage, min: 3, message: "myheritage must be at least three characters")
    |> validate_length(:werelate, min: 3, message: "werelate must be at least three characters")
    |> validate_length(:wikitree, min: 3, message: "wikitree must be at least three characters")
  end

  def full_changeset(new_person, attrs) do
IO.inspect("final changeset")
IO.inspect(new_person, label: "final new_person")
IO.inspect(attrs, label: "final attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:id,
                    :given_name, :surname,
                    :gender,
                    :birth_date, :birth_year, :birth_place,
                    :death_date, :death_year, :death_place,
                    :father, :mother,
                    :ship?, :ship_name, :ship_date,
                    :label,
                    :geni, :myheritage, :werelate, :wikitree,
                    ])
    |> validate_length(:id, is: 5)
    |> validate_format(:id, @id_regex, message: "must be one lowercase letter followed by 4 digits")
    |> validate_length(:given_name, min: 1, message: "given_name must be at least one character")
    |> validate_length(:surname, min: 1, message: "surnamemust be at least one character")
    |> validate_required([:gender])
    |> validate_length(:birth_date, min: 1, message: "birth_date must be at least one character")
    |> validate_length(:birth_year, min: 1, message: "birth_year must be at least one character")
    |> validate_length(:birth_place, min: 1, message: "birth_place must be at least one character")
    |> validate_length(:death_date, min: 1, message: "death_date must be at least one character")
    |> validate_length(:death_year, min: 1, message: "death_year must be at least one character")
    |> validate_length(:death_place, min: 1, message: "death_place must be at least one character")
    |> validate_length(:mother, min: 3, message: "mother must be at least three characters")
    |> validate_length(:father, min: 3, message: "father must be at least three characters")
    |> validate_length(:ship_name, min: 1, message: "ship_name must be at least one character - use nil in unknown or na")
    |> validate_length(:ship_date, min: 1, message: "ship_date must be at least one character - use nil in unknown or na")
    |> validate_label(:label)
    |> validate_length(:geni, min: 3, message: "geni must be at least three characters")
    |> validate_length(:myheritage, min: 3, message: "myheritage must be at least three characters")
    |> validate_length(:werelate, min: 3, message: "werelate must be at least three characters")
    |> validate_length(:wikitree, min: 3, message: "wikitree must be at least three characters")
  end

  def save(new_person) do
IO.inspect(new_person, label: "save: new_person")
    people = @data_path |> Code.eval_file() |> elem(0)
    # cleanup eg text to atoms
    clean_person = clean_up(new_person)
IO.inspect(clean_person, label: "save: clean_person")
    people
    |> Map.put(new_person.id, new_person)
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(Path.join(:code.priv_dir(:cfsjksas), "static/data/people2_ex.txt"))

  end

  def clean_up(new_person) do
    %{
      id: String.to_existing_atom(new_person.id),
      gender: new_person.gender,
      birth_date: if_nil(new_person.birth_date),
      birth_year: if_nil(new_person.birth_year),
      birth_place: if_nil(new_person.birth_place),
      death_date: if_nil(new_person.death_date),
      death_year: if_nil(new_person.death_year),
      death_place: if_nil(new_person.death_place),
      father: update_parent(new_person.father),
      mother: update_parent(new_person.mother),
      label: new_person.label,
    }
    |> update_ship(new_person.ship?, new_person.ship_name, new_person.ship_date)
    |> update_links(new_person)

  end

  defp update_ship(person_map, false, _ship_name, _ship_date) do
    # no ship so don't add
    person_map
  end
  defp update_ship(person_map, true, ship_name, ship_date) do
    # ship so add with data
    Map.put(person_map, :ship, %{ship_name: if_nil(ship_name), ship_date: if_nil(ship_date)})
  end

  defp update_links(person, new_person) do
    links = %{}
    |> update_geni(new_person.geni)
    |> update_myheritage(new_person.myheritage)
    |> update_werelate(new_person.werelate)
    |> update_wikitree(new_person.wikitree)
    Map.put(person, :links, links)
  end

  defp update_geni(link_map, "nil") do
    # no link, leave unchanged
    link_map
  end
  defp update_geni(link_map, link) do
    # add link
    Map.put(link_map, :geni, link)
  end

  defp update_myheritage(link_map, "nil") do
    # no link, leave unchanged
    link_map
  end
  defp update_myheritage(link_map, link) do
    # add link
    Map.put(link_map, :myheritage, link)
  end

  defp update_werelate(link_map, "nil") do
    # no link, leave unchanged
    link_map
  end
  defp update_werelate(link_map, link) do
    # add link
    Map.put(link_map, :werelate, link)
  end

  defp update_wikitree(link_map, "nil") do
    # no link, leave unchanged
    link_map
  end
  defp update_wikitree(link_map, link) do
    # add link
    Map.put(link_map, :wikitree, link)
  end

  defp update_parent("nil") do
    nil
  end
  defp update_parent(text) do
    String.to_existing_atom(text)
  end

  defp if_nil("nil") do
    nil
  end
  defp if_nil(text) do
    text
  end

  defp validate_label(changeset, field) do
    validate_change(changeset, field, fn ^field, value ->
      case String.split(value, ".", parts: 3) do
        [<<"gen", rest::binary>>, mp_part, _third] ->
          with {n, ""} when n >= 0 <- Integer.parse(rest),
               true <- String.length(mp_part) == n,
               true <- n <= 15,
               true <- mp_part =~ ~r/^[MP]*$/ do
            []
          else
            _ ->
              [{field,
                {"bad format",
                 [validation: :format]}}]
          end

        _ ->
          [{field,
            {"bad format",
             [validation: :format]}}]
      end
    end)
  end

end
