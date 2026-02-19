defmodule Cfsjksas.Ancestors.NewPerson do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :email, :string
    field :password, :string
    field :given_name, :string
    field :surname, :string
  end

  # base cast
  def base_changeset(new_person, attrs \\ %{}) do
IO.inspect("base changeset")
    new_person
    |> cast(attrs, [:gender, :email, :password, :id, :given_name, :surname])
  end

  # validations for step 1 only
  def step1_changeset(new_person, attrs) do
IO.inspect("step1 changeset")
IO.inspect(new_person, label: "step1 new_person")
IO.inspect(attrs, label: "step1 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:email, :password, :id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
  end

  # validations for step 2 only
  def step2_changeset(new_person, attrs) do
IO.inspect("step2 changeset")
IO.inspect(new_person, label: "step2 new_person")
IO.inspect(attrs, label: "step2 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:given_name, :surname])
  end

  # validations for step 3 only
  def step3_changeset(new_person, attrs) do
IO.inspect("step3 changeset")
IO.inspect(new_person, label: "step3 new_person")
IO.inspect(attrs, label: "step3 attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:gender])
  end

  # full validation used on final submit
  def full_changeset(new_person, attrs) do
IO.inspect("final changeset")
IO.inspect(new_person, label: "final new_person")
IO.inspect(attrs, label: "final attrs")
    new_person
    |> base_changeset(attrs)
    |> validate_required([:email, :password, :id, :given_name, :surname])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_required([:gender])
  end
end
