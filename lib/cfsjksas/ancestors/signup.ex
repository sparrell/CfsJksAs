defmodule Cfsjksas.Ancestors.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
  end

  # base cast
  def base_changeset(signup, attrs \\ %{}) do
IO.inspect("base changeset")
    signup
    |> cast(attrs, [:gender, :email, :password, :id, :first_name, :last_name])
  end

  # validations for step 1 only
  def step1_changeset(signup, attrs) do
IO.inspect("step1 changeset")
IO.inspect(signup, label: "step1 signup")
IO.inspect(attrs, label: "step1 attrs")
    signup
    |> base_changeset(attrs)
    |> validate_required([:email, :password, :id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
  end

  # validations for step 2 only
  def step2_changeset(signup, attrs) do
IO.inspect("step2 changeset")
IO.inspect(signup, label: "step2 signup")
IO.inspect(attrs, label: "step2 attrs")
    signup
    |> base_changeset(attrs)
    |> validate_required([:first_name, :last_name])
  end

  # validations for step 3 only
  def step3_changeset(signup, attrs) do
IO.inspect("step3 changeset")
IO.inspect(signup, label: "step3 signup")
IO.inspect(attrs, label: "step3 attrs")
    signup
    |> base_changeset(attrs)
    |> validate_required([:gender])
  end

  # full validation used on final submit
  def full_changeset(signup, attrs) do
IO.inspect("final changeset")
IO.inspect(signup, label: "final signup")
IO.inspect(attrs, label: "final attrs")
    signup
    |> base_changeset(attrs)
    |> validate_required([:email, :password, :id, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_required([:gender])
  end
end
