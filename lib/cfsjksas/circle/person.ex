defmodule Cfsjksas.Circle.Person do
  @moduledoc """
  Documentation for Person
  struct and processing on person
  """
  defstruct [
    :id, :mh_id, :mh_name, :rin, :uid, :upd,
    :given_name, :surname, :name_suffix, :name_prefix,
    :married_name, :also_known_as, :former_name, :nickname,
    :sex,
    :birth_date, :birth_place, :birth_note, :christening, :baptism,
    :birth_source,
    :death_date, :death_place, :death_age, :death_cause,
    :death_note, :death_source,
    :buried, :probate,
    :mh_famc, :mh_famc2, :family_of_origin,
    :description,
    :immigration, :religion,
    :naturalized, :title,
    graduation: [], will: [],
    education: [], notes: [], census: [], sources: [],
    residence: [], occupation: [], emigration: [], ordained: [],
    event: [], mh_fams: [], family_of_procreation: []
    ]

    require IEx

    @doc """
    minus_nil turns struct into map and removes 'empty' items
      ie removes nil, [], empty strings
    """
    @spec minus_nil(struct()) :: map()
    def minus_nil(item) do
      keys = Map.keys(item)
      item_map = Map.from_struct(item)
      minus_nil(keys, item_map)
    end
    def minus_nil([], item) do
      # went through all keys so now done
      item
    end
    def minus_nil([ this | rest], item) do
      new_item = case item[this] do
        nil ->
          Map.delete(item, this)
        [] ->
          Map.delete(item, this)
        "" ->
          Map.delete(item, this)

        _ ->
          # non-nil so leave unchanged
          item
      end

      # recurse thru rest of list
      minus_nil(rest, new_item)
    end

    def get_name(nil, _people) do
      # no person id, so return "unknown"
      "Unknown"
    end
    def get_name(person_id, people) do
      # return person's name
      # for now just use given name and surname if they exist
      given = case people[person_id].given_name do
        nil ->
          "Unknown"
        _ ->
          people[person_id].given_name
      end

      surname = case people[person_id].surname do
        nil ->
          "Unknown"
        _ ->
          people[person_id].surname
      end

      given <> " " <> surname
    end


  end
