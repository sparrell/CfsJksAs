defmodule Cfsjksas.Links.FindLink do
  @moduledoc """
  webscrape and find links for ancestors
  """

  require IEx
  require MapDiff

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
  defp werelate(updated_ancestors, [], _updates_done) do

    #pre_ancestors = Cfsjksas.Chart.AgentStores.get_ancestors()
    #check = MapDiff.diff(pre_ancestors, updated_ancestors)
    pruned_diff = Cfsjksas.Chart.AgentStores.get_ancestors()
    |> Cfsjksas.DevTools.CompareMaps.diff(updated_ancestors)
    IO.inspect("############")
    IO.inspect(pruned_diff)
    IO.inspect("############")
#    IO.inspect(length(Map.keys(pruned_diff)))

    # done

    count = Cfsjksas.DevTools.StoreCountPeople.value()
    IO.inspect("total people #{count}")

    updated = Cfsjksas.DevTools.StoreUpdatingLink.value()
    IO.inspect("updated #{updated}")

    done = Cfsjksas.DevTools.StoreLinkAlready.value()
    IO.inspect("links already in #{done}")

    nil_person = Cfsjksas.DevTools.StoreNilPerson.value()
    IO.inspect("nil people #{nil_person}")

    mlink = Cfsjksas.DevTools.StoreNoLinkYet.value()
    IO.inspect("no link for person #{mlink}")

    no_father = Cfsjksas.DevTools.StoreNoFather.value()
    IO.inspect("no father #{no_father}")

    no_mother = Cfsjksas.DevTools.StoreNoMother.value()
    IO.inspect("no mother #{no_mother}")

    IO.inspect("add in here ")


    IO.inspect("need to add in updating ancestor map")
    IO.inspect("need to remove these comments and actually return the data")

    # write temp file of this data
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people_try1_ex.txt")
    updated_ancestors
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(filepath)
    IO.inspect(filepath, label: "wrote ")
  end
  defp werelate(updated_ancestors, _id_list, updates_done)
      when updates_done > 10 do
    # only update the first 10 links, then skip to end
    werelate(updated_ancestors, [], updates_done)
  end
  defp werelate(updating_ancestors, [id_a | rest_ids_a], _updates_done) do
    Cfsjksas.DevTools.StoreCountPeople.increment()

  #IO.inspect("##### #{id_a} ####")

    preperson = updating_ancestors[id_a]
    # some special cases for special cases
    nil_ok? = case preperson do
      # note nil_ok? means not nil
      nil ->
        false
      _ ->
       true
    end
    person_a = case preperson do
      nil ->
        #fake empty person mapto setup next tests
      IO.inspect("#{id_a} is empty person")
        %{}
      _ ->
        # otherwise get person from map
  #       IO.inspect("#{preperson.id} #{preperson.given_name} #{preperson.surname}")
        preperson
    end

    # skip if person doesn't have links and links.werelate
    # or if person doesn't has neither mother or father
    link_ok? = Map.has_key?(person_a, :links)
              and Map.has_key?(person_a.links, :werelate)
              and String.valid?(person_a.links.werelate)
              and String.length(person_a.links.werelate) > 5
    father_ok? = Map.has_key?(person_a, :father)
              and is_atom(person_a.father)
              and not is_nil(person_a.father)
    mother_ok? = Map.has_key?(person_a, :mother)
              and is_atom(person_a.mother)
              and not is_nil(person_a.mother)

    # update (or not) ancestors with father/mother links for id_a, and recurse
    updating_ancestors
    |> update_father(nil_ok?, link_ok?, father_ok?, id_a)
    |> update_mother(nil_ok?, link_ok?, mother_ok?, id_a)
    |> werelate(rest_ids_a, Cfsjksas.DevTools.StoreUpdatingLink.value())

  end

  defp update_father(updating_ancestors, false = _nil_ok?, _link_ok?, _father_ok?, _id_a) do
    # no person so nothing to update
    Cfsjksas.DevTools.StoreNilPerson.increment()
    updating_ancestors
  end
  defp update_father(updating_ancestors, true = _nil_ok?, false = _link_ok?, _father_ok?, _id_a) do
    # person doesn't have link so nothing to update
    Cfsjksas.DevTools.StoreNoLinkYet.increment()
    updating_ancestors
  end
  defp update_father(updating_ancestors, true = _nil_ok?, true =_link_ok?, false = _father_ok?, _id_a) do
    # person doesn't have father so nothing to update
    Cfsjksas.DevTools.StoreNoFather.increment()
    updating_ancestors
  end
  defp update_father(updating_ancestors, true = _nil_ok?, true =_link_ok?, true = _father_ok?, id_a) do
    # update father
    # conditions are  met for map to be updated so continue
    person = updating_ancestors[id_a] # this person
    # get this person's werelate link
    page_to_scrape = person.links.werelate

    # father id
    father_id_a = person.father
    father_a = Cfsjksas.Ancestors.GetAncestors.person(father_id_a)
    already_link? = Map.has_key?(father_a, :links)
              and Map.has_key?(father_a.links, :werelate)
              and String.valid?(father_a.links.werelate)
              and String.length(father_a.links.werelate) > 5

    # if alredy link, move on, else, add link
    case already_link? do
      true ->
        # already has link so do nothing
        Cfsjksas.DevTools.StoreLinkAlready.increment()
        updating_ancestors
      false ->
        # screen scrape link off werelate
        Cfsjksas.DevTools.StoreUpdatingLink.increment()
        dad_link = screen_scrape(page_to_scrape, :father)
        add_father_link(updating_ancestors, father_id_a, dad_link)
    end
  end

  defp update_mother(updating_ancestors, false = _nil_ok?, _link_ok?, _mother_ok?, _id_a) do
    # no person so nothing to update
    Cfsjksas.DevTools.StoreNilPerson.increment()
    updating_ancestors
  end
  defp update_mother(updating_ancestors, true = _nil_ok?, false = _link_ok?, _mother_ok?, _id_a) do
    # person doesn't have link so nothing to update
    Cfsjksas.DevTools.StoreNoLinkYet.increment()
    updating_ancestors
  end
  defp update_mother(updating_ancestors, true = _nil_ok?, true =_link_ok?, false = _mother_ok?, _id_a) do
    # person doesn't have mother so nothing to update
    Cfsjksas.DevTools.StoreNoMother.increment()
    updating_ancestors
  end
  defp update_mother(updating_ancestors, true = _nil_ok?, true =_link_ok?, true = _mother_ok?, id_a) do
    # update mother
    # conditions are  met for map to be updated so continue
    person = updating_ancestors[id_a] # this person
    # get this person's werelate link
    page_to_scrape = person.links.werelate

    # mother id
    mother_id_a = person.mother
    mother_a = Cfsjksas.Ancestors.GetAncestors.person(mother_id_a)
    already_link? = Map.has_key?(mother_a, :links)
              and Map.has_key?(mother_a.links, :werelate)
              and String.valid?(mother_a.links.werelate)
              and String.length(mother_a.links.werelate) > 5

    # if alredy link, move on, else, add link
    case already_link? do
      true ->
        # already has link so do nothing
        Cfsjksas.DevTools.StoreLinkAlready.increment()
        updating_ancestors
      false ->
        # screen scrape link off werelate
        Cfsjksas.DevTools.StoreUpdatingLink.increment()
        mom_link = screen_scrape(page_to_scrape, :mother)
        add_mother_link(updating_ancestors, mother_id_a, mom_link)
    end
  end


  defp screen_scrape(page_to_scrape, parent) do

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

  def add_father_link(updating_ancestors, father_id_a, dad_link) do
    IO.inspect("adding  #{father_id_a} #{dad_link}")

    put_in(updating_ancestors[father_id_a][:links][:werelate], dad_link)
  end

  def add_mother_link(updating_ancestors, mother_id_a, mom_link) do
    IO.inspect("need to do add_mother_link for #{mother_id_a} #{mom_link}")
    updating_ancestors
  end


  @doc """
  input a person's id_a
  look up their wereleate link, mother's id, father's id
  screen scrape that page
  derive links for father and mother
  """

  def werelate2(updating_ancestors, false, _id_a) do
    # conditions are not met for id_a to be updated so continue
    updating_ancestors
  end

  def werelate2(updating_ancestors, true, id_a) do
    person = Cfsjksas.Ancestors.GetAncestors.person(id_a) # this person
    # get this person's werelate link
    page_to_scrape = person.links.werelate
    # setup function
    req = (Req.new() |> ReqEasyHTML.attach())

    # ping web and get response
    response = Req.get!(req, url: page_to_scrape)

    parent_div = response.body["div.wr-infobox-parentssiblings ul"]

    tree = EasyHTML.to_tree(parent_div)
    # peel ...
    [{_, _, [f_tup, _m_tup]}] = tree
    {_, _, [f_tup2, _]} = f_tup
    {_,_,[_, _, f_tup3]} = f_tup2
    {_,[f_tup4,_],_} = f_tup3
    {"href", f_prelink} =f_tup4

    f_link = "http://werelate.org" <> f_prelink

    IO.inspect(f_link, label: "f_link")

    # to do
    updated_ancestors = updating_ancestors
    # return updated ancestors
    updated_ancestors

  end

end
