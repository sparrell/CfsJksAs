defmodule Cfsjksas.Links.Utils do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx
  require MapDiff

  def print_werelate_counts() do

    IO.inspect("###############***********###############")

    count = Cfsjksas.DevTools.StoreCountPeople.value()
    IO.inspect("total people #{count}")

    no_child_map = Cfsjksas.DevTools.StoreNoChildMap.value()
    IO.inspect("no_child_map #{no_child_map}")

    child_no_werelate = Cfsjksas.DevTools.StoreChildNoWerelate.value()
    IO.inspect("child_no_werelate #{child_no_werelate}")

    child_no_werelate_list = inspect(Cfsjksas.DevTools.StoreChildNoWerelateList.get_list())
    IO.inspect("child_no_werelate #{child_no_werelate_list}")

    updated = Cfsjksas.DevTools.StoreUpdatingLink.value()
    IO.inspect("updated #{updated}")

    already = Cfsjksas.DevTools.StoreLinkAlready.value()
    IO.inspect("links already in #{already}")

    nil_person = Cfsjksas.DevTools.StoreNilPerson.value()
    IO.inspect("nil people #{nil_person}")

    mlink = Cfsjksas.DevTools.StoreNoLinkYet.value()
    IO.inspect("no link for person #{mlink}")

    no_father = Cfsjksas.DevTools.StoreNoFather.value()
    IO.inspect("no father #{no_father}")

    no_mother = Cfsjksas.DevTools.StoreNoMother.value()
    IO.inspect("no mother #{no_mother}")

    :ok
  end

  @doc """
  go to website, screen scrape, parse into desired info
  """
  def screen_scrape(:werelate, page_to_scrape) do
    # setup scrape function
    req = (Req.new() |> ReqEasyHTML.attach())

    # ping web and get response
    response = Req.get!(req, url: page_to_scrape)

    # pull the parent div
    parent_div = response.body["div.wr-infobox-parentssiblings"]

    # pull the list elements from parent_div
    items = parent_div["ul li"]


    # loop thru the items
    for item <- items do
      label = item["span.wr-infobox-label"]
      label_txt = EasyHTML.text(label)
      if (label_txt == "F")
          or (label_txt == "M")
          do
        # kludge using lazy since couldn't get ReqEasyHTML to work right
        predraft_list = item["a"]
        |> EasyHTML.to_html()
        |> LazyHTML.from_fragment()
        |> LazyHTML.attribute("href")
        |> List.first()

        "https://www.werelate.org" <> predraft_list
        end
    end

#    # return parent link
#    case parent do
#          :father ->
#            List.first(parent_list)
#          :mother ->
#            [_, second] = parent_list
#            second
#    end

  end

  def precheck(updating_ancestors, :werelate, id_a) do
    child_a = updating_ancestors[id_a]
    # validate child is map with a werelate link
    ## and has either a mother or father or both

    # conditions checked:
    ## child is a map
    ## child has links key
    ## links is map and has werelate key
    ## father exists (do if yes, skip if has link already)
    ## mother exists (do if yes, skip if has link already)


    child_check = is_map(child_a)
          and Map.has_key?(child_a, :links)
          and Map.has_key?(child_a.links, :werelate)
    #IO.inspect(child_check, label: "child_check")

    # if child_check is true, then skip_father is true if father exists and is an atom
    check_father = child_check
                and Map.has_key?(child_a, :father)
                and not is_nil(child_a.father)
                and is_atom(child_a.father)
    check_father_link = case check_father do
      false ->
        false
      true ->
        father = updating_ancestors[child_a.father]
        is_map(father)
        and Map.has_key?(father, :links)
        and is_map(father.links)
        and Map.has_key?(father.links, :werelate)
        and link_check(father.links.werelate)
    end
    if check_father_link do
        Cfsjksas.DevTools.StoreLinkAlready.increment()
    end
    #IO.inspect(check_father_link, label: "check_father_link")
    # similar for mother
    check_mother = child_check
                and Map.has_key?(child_a, :mother)
                and not is_nil(child_a.mother)
                and is_atom(child_a.mother)

    check_mother_link = case check_mother do
      false ->
        false
      true ->
        mother = updating_ancestors[child_a.mother]
        is_map(mother)
        and Map.has_key?(mother, :links)
        and is_map(mother.links)
        and Map.has_key?(mother.links, :werelate)
        and link_check(mother.links.werelate)
    end
    if check_mother_link do
        Cfsjksas.DevTools.StoreLinkAlready.increment()
    end
    #IO.inspect(check_mother_link, label: "check_mother_link")

    skip_father = case {child_check, check_father, check_father_link} do
      {true, true, false} ->
        # only condition to not skip is
        ## child has info on father
        ## and father doesn't already have link
        false
      {_, _, _} ->
        # skip
        true
    end

    skip_mother = case {child_check, check_mother, check_mother_link} do
      {true, true, false} ->
        # only condition to not skip is
        ## child has info on mother
        ## and mother doesn't already have link
        false
      {_, _, _} ->
        # skip
        true
    end

    skip = case {child_check, skip_father, skip_mother} do
      {false, _, _} ->
        # skip since failed child_check
        true
      {true, true, true} ->
        # skip since both mother and father already have links
        true
      _ ->
        # otherwise screen scrape
        false
    end

    #IO.inspect(skip, label: "skip")
    #IO.inspect(skip_father, label: "skip_father")
    #IO.inspect(skip_mother, label: "skip_mother")

    # continue on updates
{updating_ancestors,
  skip,
  skip_father,
  skip_mother,
}
  end

  defp link_check(link) do
    x = String.starts_with?(link, "https://www.werelate.org/")
    or String.starts_with?(link, "http://www.werelate.org/")
    or String.starts_with?(link, "https://werelate.org/")
    or String.starts_with?(link, "http://werelate.org/")
if not x do
  IEx.pry()
end
    x
  end
end
