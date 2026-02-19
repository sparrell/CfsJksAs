defmodule Cfsjksas.Ancestors.AddPerson do
  use Ecto.Schema
  import Ecto.Changeset

  @id_regex ~r/^[a-z][0-9]{4}$/

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
    field :ship?, Ecto.Enum, values: [true, false], default: false
    field :ship_name, :string, default: "nil"
    field :ship_date, :string, default: "nil"
    field :label, :string
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
  end

  defp validate_label(changeset, field) do
    validate_change(changeset, field, fn ^field, value ->
      case String.split(value, ".", parts: 3) do
        [<<"gen", rest::binary>>, mp_part, third] ->
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
