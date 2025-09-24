defmodule Cfsjksas.Links.Utils do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx
  require MapDiff

  def print_werelate_counts() do

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
  def screen_scrape(:werelate, page_to_scrape, parent) do
    # add comment
    # setup scrape function
    req = (Req.new() |> ReqEasyHTML.attach())

    # ping web and get response
    IO.inspect(page_to_scrape, label: "page_to_scrape")
    response = Req.get!(req, url: page_to_scrape)

    # pull the parent div
    parent_div = response.body["div.wr-infobox-parentssiblings"]

    # pull the list elements from parent_div
    items = parent_div["ul li"]


    # loop thru the items
    out = for item <- items do
      label = item["span.wr-infobox-label"]
      label_txt = EasyHTML.text(label)
      if ((label_txt == "F") and (parent == :father))
          or ((label_txt == "M") and (parent == :mother))
          do
        # kludge using lazy since couldn't get ReqEasyHTML to work right
        predraft_list = item["a"]
        |> EasyHTML.to_html()
        |> LazyHTML.from_fragment()
        |> LazyHTML.attribute("href")
        |> List.first()

        IO.inspect(predraft_list)

        "http://werelate.org" <> predraft_list <> ","
        end
    end

    # return parent link
    case parent do
          :father ->
            List.first(out)
          :mother ->
            [_, second] = out
            second
    end

  end

  def precheck({updated_ancestors,
                id_a,
                }) do
#cheat for now, fill in code
skip = true
skip_father = true
skip_mother = true
    # continue on updates
{updated_ancestors,
  id_a,
  skip,
  skip_father,
  skip_mother,
}
  end
end
