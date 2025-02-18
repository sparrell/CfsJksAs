defmodule Cfsjksas.Tools.Person do
  # routines processing "person" as input

  def get_birth_place(person) do
    case person.birth_place do
      nil ->
        "Unknown"
      _ ->
        person.birth_place
    end
  end

  def get_death_place(person) do
    case person.death_place do
      nil ->
        "Unknown"
      _ ->
        person.death_place
    end
  end


end
