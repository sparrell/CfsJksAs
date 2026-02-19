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

  # validations for step 1 only
  def step1_changeset(new_person, attrs) do
IO.inspect("step1 changeset")
IO.inspect(new_person, label: "step1 new_person")
IO.inspect(attrs, label: "step1 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:id])
    |> validate_length(:id, is: 5)
    |> validate_format(:id, @id_regex, message: "must be one lowercase letter followed by 4 digits")
  end

  def step2_changeset(new_person, attrs) do
IO.inspect("step2 changeset")
IO.inspect(new_person, label: "step2 new_person")
IO.inspect(attrs, label: "step2 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:given_name, :surname])
    |> validate_length(:given_name, min: 1, message: "given_name must be at least one character")
    |> validate_length(:surname, min: 1, message: "surnamemust be at least one character")
  end

end
