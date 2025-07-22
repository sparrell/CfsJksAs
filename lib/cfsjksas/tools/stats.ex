defmodule Cfsjksas.Ancestors.Stats do
  @moduledoc """
  dervie info from raw data
  """

  @doc """
    for a given key, give info about people with that key
  """
  def people_key(key) do
    # stat map
    %{
      total: 0,
      no_key: 0,
      has_key: 0,
      has_nil_value: 0,
    }
    |> people_key(key, Cfsjksas.Ancestors.GetAncestors.all_ids())
  end
  def people_key(stat_map, _key, []) do
    # done
    stat_map
  end
  def people_key(stat_map, key, [this_id | rest_ids]) do
    #
    person = Cfsjksas.Ancestors.GetAncestors.person((this_id))

    people_key(stat_map, key, person, Map.has_key?(person, key))
    |> people_key(key, rest_ids)

  end
  def people_key(stat_map, key, person, :true) do
    # has key
    case person[key] do
      nil ->
        # nil so update stat_map and return it
        stat_map
        |> update_in([:total], &( &1 + 1))
        |> update_in([:has_key], &( &1 + 1))
        |> update_in([:has_nil_value], &( &1 + 1))
      _ ->
        # non-nil value
        # see if exists already
        case Map.has_key?(stat_map, person[key]) do
          :true ->
            # inc by one and return stat_map
            stat_map
            |> update_in([:total], &( &1 + 1))
            |> update_in([:has_key], &( &1 + 1))
            |> update_in([person[key]], &( &1 + 1))
          :false ->
            # add to map with value 1 and return
            stat_map
            |> update_in([:total], &( &1 + 1))
            |> update_in([:has_key], &( &1 + 1))
            |> update_in([person[key]], fn _ -> 0 end)
        end
    end
  end
  def people_key(stat_map, _key, _person, :false) do
    # does not have key
    ## so updafe stat_map and return it

    stat_map
    |> update_in([:total], &( &1 + 1))
    |> update_in([:no_key], &( &1 + 1))
  end


end
