defmodule Cfsjksas.DevTools.CompareMaps do
  @moduledoc """
  routines for comparing maps
  """
  require IEx
  require MapDiff

  def diff(map1,map2) do
    MapDiff.diff(map1, map2)
    |> prune()
  end

  def prune(%{changed: :equal} = _map), do: nil

  def prune(%{changed: :map_change, value: value, added: added, removed: removed} = _map) do
    pruned_value = prune_map(value)
    pruned_added = prune_map(added)
    pruned_removed = prune_map(removed)
    %{
      changed: :map_chane,
      value: pruned_value,
      added: pruned_added,
      removed: pruned_removed,
    }
  end

  def prune(%{changed: :primitive_change} = map), do: map

  def prune(other), do: other

  def prune_map(map) when is_map(map) do
    map
    |> Enum.reduce(%{}, fn
      {_, %{changed: :equal}}, acc -> acc
      {k,v}, acc -> Map.put(acc, k, prune(v))
      end)
  end


end
