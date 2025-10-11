defmodule Cfsjksas.Links.Wikitree do
  @moduledoc """
  werelate utils for screenscraping
  """

  require IEx

  def screenscrape({updating_ancestors,
                    true = _skip,
                    _skip_father,
                    _skip_mother,
                    }, _id_a) do
    # skip
    Cfsjksas.DevTools.StoreChildNoWerelate.increment()
IO.inspect("update to count agent counts wo being werelate specific")
    { nil,
      updating_ancestors,
      true,
      true,
      true,
    }
  end

  def screenscrape({updating_ancestors,
                    false = skip,
                    skip_father,
                    skip_mother,
                    }, id_a) do
    # skip = false so do screenscrape
    child_a = updating_ancestors[id_a]
    child_link = child_a.links.wikitree
    links = Cfsjksas.Links.Utils.screen_scrape(:wikitree, child_link)

    {links,
      updating_ancestors,
      skip,
      skip_father,
      skip_mother,
    }
  end

  def update_father({screenscape,
                    updated_ancestors,
                    true = skip,
                    skip_father,
                    skip_mother,
                    }, _id_a) do

    # don't update father since skipping entirely

    # recurse on to mother
    {screenscape,
      updated_ancestors,
      skip,
      skip_father,
      skip_mother,
    }
  end
  def update_father({screenscape,
                    updated_ancestors,
                    false = skip,
                    true = skip_father,
                    skip_mother,
                    }, _id_a) do

    # don't update father,
    Cfsjksas.DevTools.StoreNoFather.increment()
    # recurse on to mother
    {screenscape,
      updated_ancestors,
      skip,
      skip_father,
      skip_mother,
    }
  end
  def update_father({screenscape,
                    updating_ancestors,
                    false = skip,
                    false = skip_father,
                    skip_mother,
                    }, id_a) do
    father_link = List.first(screenscape)
    child_a = updating_ancestors[id_a]
    father_id_a = child_a.father
    # validate father_link exists and isn't to special page
    bad_screenscape = (father_link == nil) or (String.contains?(father_link, "Special"))
    case bad_screenscape do
      true ->
        # webpage doesn't have father yer
        Cfsjksas.DevTools.StoreNoLinkYet.increment()
        IO.inspect("*** no page for father #{inspect(father_id_a)}")
      # continue on to mother
        {screenscape,
          updating_ancestors,
          skip,
          skip_father,
          skip_mother,
        }
      false ->
        # update map
        Cfsjksas.DevTools.StoreUpdatingLink.increment()
        IO.inspect("adding  #{father_id_a} #{father_link}")
        updated_ancestors = put_in(updating_ancestors[father_id_a][:links][:wikitree], father_link)

        # continue on to mother
        {screenscape,
          updated_ancestors,
          skip,
          skip_father,
          skip_mother,
        }
    end

  end

###############

  def update_mother({_screenscape,
                    updated_ancestors,
                    true = _skip,
                    _skip_father,
                    _skip_mother,
                    }, _id_a) do

    # don't update mother since skipping entirely
    # recurse on to next person
    updated_ancestors
  end
  def update_mother({_screenscape,
                    updated_ancestors,
                    _skip,
                    _skip_father,
                    true = _skip_mother,
                    }, _id_a) do

    # don't update mother,
    Cfsjksas.DevTools.StoreNoMother.increment()
    # recurse on to next person
    updated_ancestors
  end
  def update_mother({screenscape,
                    updating_ancestors,
                    _skip,
                    _skip_father,
                    false = _skip_mother,
                    }, id_a) do

#    mother_link = if (screenscape == nil) or (screenscape == []) do
#      nil
#    else
#      [_, second] = screenscape
#      second
#    end
    mother_link = cond do
      screenscape == nil ->
        nil
      screenscape == [] ->
        nil
      length(screenscape) == 1 ->
        nil
      true ->
        [_, second] = screenscape
        second
    end

    child_a = updating_ancestors[id_a]
    mother_id_a = child_a.mother

    # validate mother_link exists and isn't to special page
    bad_screenscape = (mother_link == nil) or (String.contains?(mother_link, "Special"))
    case bad_screenscape do
      true ->
        # webpage doesn't have mother yer
        Cfsjksas.DevTools.StoreNoLinkYet.increment()
        IO.inspect("*** no page for mother #{inspect(mother_id_a)}")
        # iterate on
        updating_ancestors
      false ->
        Cfsjksas.DevTools.StoreUpdatingLink.increment()
        Cfsjksas.DevTools.StoreUpdatingLink.increment()
        IO.inspect("adding  #{mother_id_a} #{mother_link}")
        updated_ancestors = put_in(updating_ancestors[mother_id_a][:links][:wikitree], mother_link)

        # recurse on to next person
        updated_ancestors
    end

  end

end
