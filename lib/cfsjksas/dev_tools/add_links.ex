defmodule Cfsjksas.DevTools.AddLinks do
  @moduledoc """
  add in missing links
  """

  def empty_links(people) do
    updated_people =
      Enum.into(people, %{}, fn {outer_key, inner_map} ->
        updated_inner_map =
          case Map.has_key?(inner_map, :links) do
            true -> inner_map
            false -> Map.put(inner_map, :links, %{})
          end

      {outer_key, updated_inner_map}
      end)

    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people_try2_ex.txt")

    Cfsjksas.Tools.Print.format_ancestor_map(updated_people)
    |> Cfsjksas.Tools.Print.write_file(filepath)

  end
end
