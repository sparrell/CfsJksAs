defmodule Cfsjksas.Links.FindWeRelate do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx

  @doc """
  for a given ancestor, check their relations make sense
  """
  def parents(id_a) do
    ids = Cfsjksas.Ancestors.GetAncestors.all_ids() # all people need?
    person = Cfsjksas.Ancestors.GetAncestors.person(id_a) # this person
    # get this person's werelate link
  end
end
