defmodule Cfsjksas.Links.FindLink do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx

  @doc """
  walk thru all id_a's in gen order
  finding their father and mother
  [werelate, geni, ...] links
  if appropriate
  """

  def update(:myheritage = link_source) do
    IO.inspect("#{link_source} not implemented yet")
  end
  def update(:geni = link_source) do
    IO.inspect("#{link_source} not implemented yet")
  end
  def update(:wikitree = link_source) do
    # zero dev counts
    Cfsjksas.DevTools.StoreReset.zero_counts()

    all_ids_a = Cfsjksas.Ancestors.AgentStores.id_a_by_gen()
    IO.inspect("length of all_ids_a #{length(all_ids_a)}")
    # initialize updated ancestors with existing ancestor map
    starting_ancestors = Cfsjksas.Ancestors.AgentStores.get_ancestors()
    updates_done = 0

    process_people(starting_ancestors, link_source, all_ids_a, updates_done)
  end
  def update(:werelate = link_source) do
    # zero dev counts
    Cfsjksas.DevTools.StoreReset.zero_counts()

    IO.inspect("resolve which parsing")
    all_ids_a = Cfsjksas.Ancestors.AgentStores.id_a_by_gen()
    IO.inspect("length of all_ids_a #{length(all_ids_a)}")
    # initialize updated ancestors with existing ancestor map
    starting_ancestors = Cfsjksas.Ancestors.AgentStores.get_ancestors()
    updates_done = 0

    process_people(starting_ancestors, link_source, all_ids_a, updates_done)
  end

  defp process_people(updated_ancestors, link_source, [], _updates_done) do
    # done cycling thru id's

    # print some stats
    case link_source do
      :werelate ->
        :ok = Cfsjksas.Links.Utils.print_werelate_counts()
    end

    # write temp file of this data
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people_try1_ex.txt")
    updated_ancestors
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(filepath)
    IO.inspect(filepath, label: "wrote ")
  end
  defp process_people(updated_ancestors, link_source, _id_list, updates_done)
      when updates_done > 10 do
    # only update the first 10 links, then skip to end
    process_people(updated_ancestors, link_source, [], updates_done)
  end
  defp process_people(updating_ancestors, :werelate, [id_a | rest_ids_a], _updates_done) do
    Cfsjksas.DevTools.StoreCountPeople.increment()
    # objective is to update parent's links
    # by screen scraping the child's werelate page

#IO.inspect("##### #{id_a} ####")
    updating_ancestors
    |> Cfsjksas.Links.Utils.precheck(:werelate, id_a)
    |> Cfsjksas.Links.Werelate.screenscrape(id_a)
    |> Cfsjksas.Links.Werelate.update_father(id_a)
    |> Cfsjksas.Links.Werelate.update_mother(id_a)
    # pass on updated ancestors, recalc updates_done
    |> process_people(:werelate, rest_ids_a, Cfsjksas.DevTools.StoreUpdatingLink.value())

  end
  defp process_people(updating_ancestors, :wikitree, [id_a | rest_ids_a], _updates_done) do
    Cfsjksas.DevTools.StoreCountPeople.increment()
    # objective is to update parent's links
    # by screen scraping the child's werelate page

IO.inspect("##### #{id_a} ####")
    updating_ancestors
    |> Cfsjksas.Links.Utils.precheck(:wikitree, id_a)
    |> Cfsjksas.Links.Wikitree.screenscrape(id_a)
    |> Cfsjksas.Links.Wikitree.update_father(id_a)
    |> Cfsjksas.Links.Wikitree.update_mother(id_a)
    # pass on updated ancestors, recalc updates_done
    |> process_people(:wikitree, rest_ids_a, Cfsjksas.DevTools.StoreUpdatingLink.value())

  end

end
