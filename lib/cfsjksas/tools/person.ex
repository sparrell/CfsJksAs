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

  def surname(person) do
    # get person name
    case person.surname do
      nil ->
        "Unknown"
      _ ->
        person.surname
    end
    end

    def given_name(person) do
      # get person name
      case person.given_name do
        nil ->
          "Unknown"
        _ ->
          person.given_name
      end
      end

    def person_name(person) do
      # get person name
      given_name(person) <> " " <> surname(person)
      end



end
