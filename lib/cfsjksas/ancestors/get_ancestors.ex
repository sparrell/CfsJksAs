defmodule Cfsjksas.Ancestors.GetAncestors do
  @moduledoc """
  Turns text file of ancestors in elxir map

  all_ancestors() returns map with everyone
  all_ids() returns list of everyone's ids
  person(id) returns the person's individual map

  """

  @data_path Application.app_dir(:cfsjksas, ["priv", "static", "data", "people_ex.txt"])
  @external_resource @data_path
  @ancestors @data_path |> Code.eval_file() |> elem(0)

  def all_ancestors() do
    @ancestors
  end

  def all_ids() do
    Map.keys(@ancestors)
  end

  def person(id) do
    @ancestors[id]
  end

end
