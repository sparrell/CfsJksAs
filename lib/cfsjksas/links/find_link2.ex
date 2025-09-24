defmodule Cfsjksas.Links.FindLink2 do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx

  @doc """
  walk thru all id_a's in gen order
  finding their father and mother werelate links if appropriate
  """
  def werelate() do
    # zero dev counts
    Cfsjksas.DevTools.StoreReset.zero_counts()

    IO.inspect("resolve which parsing")
    all_ids_a = Cfsjksas.Chart.AgentStores.id_a_by_gen()
    IO.inspect("length of all_ids_a #{length(all_ids_a)}")
    # initialize updated ancestors with existing ancestor map
    updating_ancestors = Cfsjksas.Chart.AgentStores.get_ancestors()
    updates_done = 0
    werelate(updating_ancestors, all_ids_a, updates_done)
  end

  defp werelate(updating_ancestors, [], _updates_done) do
    # done cycling thru id's

    # print some stats
    :ok = Cfsjksas.Links.Utils.print_werelate_counts()

    # write temp file of this data
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people_try1_ex.txt")
    updating_ancestors
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(filepath)
    IO.inspect(filepath, label: "wrote ")
  end
  defp werelate(updated_ancestors, _id_list, updates_done)
      when updates_done > 10 do
    # only update the first 10 links, then skip to end
    IEx.pry()
    werelate(updated_ancestors, [], updates_done)
  end
  defp werelate(updating_ancestors, [id_a | rest_ids_a], updates_done) do
    Cfsjksas.DevTools.StoreCountPeople.increment()
    # objective is to update parent's links
    # by screen scraping the child's werelate page

IO.inspect("##### #{id_a} ####")

    child_a = updating_ancestors[id_a]
#IO.inspect(child_a, label: "child_a")
    # validate child is map
    child_exists(updating_ancestors, id_a, rest_ids_a, updates_done, child_a)
  end

  defp child_exists(updating_ancestors, _id_a, rest_ids_a, updates_done, child_a)
      when not is_map(child_a) do
    Cfsjksas.DevTools.StoreNoChildMap.increment()
    # person is not a map, so jump to next person
    werelate(updating_ancestors, rest_ids_a, updates_done)
  end
  defp child_exists(updating_ancestors, _id_a, rest_ids_a, updates_done,child_a)
      when child_a == %{} do
    # person is empty map, so jump to next person
    IEx.pry()
    werelate(updating_ancestors, rest_ids_a, updates_done)
  end
  defp child_exists(updating_ancestors, id_a, rest_ids_a, updates_done, child_a) do
    # ok to move forward and check child has myheritage link
    link_ok = Map.has_key?(child_a, :links)
      and Map.has_key?(child_a.links, :werelate)
    case link_ok do
      false ->
        # no page to screen scape so continue to next person
        Cfsjksas.DevTools.StoreChildNoWerelate.increment()
        Cfsjksas.DevTools.StoreChildNoWerelateList.add_to_list(id_a)
        werelate(updating_ancestors, rest_ids_a, updates_done)
      true ->
        # continue evaluating, sanity check link
        child_link = child_a.links.werelate
        check_child_link(updating_ancestors,
                        id_a,
                        rest_ids_a,
                        updates_done,
                        child_a)
    end
  end

  defp check_child_link(updating_ancestors,
                        id_a,
                        rest_ids_a,
                        updates_done,
                        child_a) do

    child_link = child_a.links.werelate
    link_ok? = case child_link do
      nil ->
        false
      _ ->
        String.starts_with?(child_link, "https://www.werelate.org/")
    end
    check_child_link(updating_ancestors,
                    id_a,
                    rest_ids_a,
                    updates_done,
                    child_a,
                    link_ok?,
                    child_link)
  end

  defp check_child_link(updating_ancestors,
                      _id_a,
                      rest_ids_a,
                      updates_done,
                      _child_a,
                      false = _link_ok?,
                      _child_link) do
    # no link to screen scrape so move on
    Cfsjksas.DevTools.StoreNoLinkYet.increment()
    werelate(updating_ancestors, rest_ids_a, updates_done)
  end
  defp check_child_link(updating_ancestors,
                      id_a,
                      rest_ids_a,
                      updates_done,
                      child_a,
                      true = _link_ok?,
                      child_link) do
    # should be a valid link so do next check before screen scrape
    # do father then do mother
    # if father's map entry already has werelate link,
    ## then no need to update and go ot mother
    father_id_a = child_a.father
    father_a = updating_ancestors[father_id_a]
    father_links = Map.has_key?(father_a.links, :werelate)
IEx.pry()
    xxx = Cfsjksas.Links.Utils.screen_scrape(:werelate, child_link, :father)
IEx.pry()
    ## above belongs in later function once know you need to screen scape

  end


end
