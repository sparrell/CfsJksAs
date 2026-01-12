defmodule Cfsjksas.Tools.LineSort do
  @moduledoc """
  helper function for wierd sort to make 'circle' more likely to be high/low than wide
  this is becuase printer can print taller over wider
  overall so font won't get too small
  """

  @triple_order [
    [:p, :p, :p],
    [:m, :m, :m],
    [:p, :p, :m],
    [:m, :m, :p],
    [:p, :m, :p],
    [:m, :p, :m],
    [:p, :m, :m],
    [:m, :p, :p]
  ]

  @triple_rank_map @triple_order
                   |> Enum.with_index()
                   |> Map.new()

  @doc """
  Write the relations map to `path` as a pretty-printed map,
  with keys sorted in the specified custom order.
  """
  def make_sorted_text(relations_map) when is_map(relations_map) do
    sorted_pairs =
      relations_map
      |> Map.to_list()
      |> Enum.sort_by(fn {key, _val} -> sort_key(key) end)

    # Build a new map from the sorted pairs.
    # Note: the *text* produced by inspect/2 will show keys in this order,
    # although maps themselves are not ordered at runtime.
    #sorted_map = Map.new(sorted_pairs)

    #inspect(sorted_map, pretty: true, limit: :infinity, printable_limit: :infinity)
    inspect(sorted_pairs, pretty: true, limit: :infinity, printable_limit: :infinity)
  end

  # --- sort key ---

  def sort_key(key) when is_list(key) do
    {
      length(key),
      prefix_rank(key),
      tail_key(key)
    }
  end

  # --- prefix_rank/1 ---

  defp prefix_rank([]), do: {0, []}
  defp prefix_rank([a]), do: {1, [a]}
  defp prefix_rank([a, b]), do: {2, [a, b]}

  defp prefix_rank([a, b, c | _]) do
    triple = [a, b, c]

    base = 3
    count = length(@triple_order)

    case Map.fetch(@triple_rank_map, triple) do
      {:ok, idx} -> {base + idx, triple}
      :error -> {base + count, triple}
    end
  end

  # --- tail_key/1 ---

  # :p < :m under Erlang term ordering, so comparing the tail list directly
  # gives the desired "p before m" behavior. [web:20][web:29]

  defp tail_key([]), do: []
  defp tail_key([_a]), do: []
  defp tail_key([_a, _b]), do: []
  defp tail_key([_a, _b, _c | rest]), do: rest
end
