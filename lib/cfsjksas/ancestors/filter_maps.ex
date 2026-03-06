defmodule Cfsjksas.Ancestors.FilterMaps do
  @moduledoc """
  people_with_key(map, key, value)
    returns list of all outer map keys that have inner map key/value
  """

  @doc """
  for map people, filter out only inner maps that have key/value
  and then list those outer map keys
  e.g. find all the :person_id in people that have father: :p1234
  """
  def people_with_key(people, key, value) do
    people
    |> Enum.filter(fn {_key, person} ->
      is_map(person) and Map.get(person, key) == value
    end)
    |> Enum.map(fn {key, _person} -> key end)
  end
end
