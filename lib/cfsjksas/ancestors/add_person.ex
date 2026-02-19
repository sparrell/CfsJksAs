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
  end

  # base cast
  def base_changeset(new_person, attrs \\ %{}) do
IO.inspect("base changeset")
    new_person
    |> cast(attrs, [:id, :gender, :given_name, :surname])
  end

  # validations for step 1
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
    |> validate_length(:surname, min: 1, message: "surnamemust be at least one character")
  end

  def step3_gender_changeset(new_person, attrs) do
IO.inspect("step3 changeset")
IO.inspect(new_person, label: "step3 new_person")
IO.inspect(attrs, label: "step3 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:gender])
  end

  def full_changeset(new_person, attrs) do
IO.inspect("final changeset")
IO.inspect(new_person, label: "final new_person")
IO.inspect(attrs, label: "final attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:id, :gender, :given_name, :surname])
    |> validate_length(:id, is: 5)
    |> validate_format(:id, @id_regex, message: "must be one lowercase letter followed by 4 digits")
    |> validate_length(:given_name, min: 1, message: "given_name must be at least one character")
    |> validate_length(:surname, min: 1, message: "surnamemust be at least one character")
    |> validate_required([:gender])
  end


end
