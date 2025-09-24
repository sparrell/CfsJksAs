defmodule Cfsjksas.Links.Werelate do
  @moduledoc """
  werelate utils
  """

  require IEx


  def update_father({updated_ancestors,
                    id_a,
                    true = skip,
                    skip_father,
                    skip_mother,
                    }) do

    # don't update father,
    # recurse on to mother
    {updated_ancestors,
      id_a,
      skip,
      skip_father,
      skip_mother,
    }
  end
  def update_father({updated_ancestors,
                    id_a,
                    skip,
                    true = skip_father,
                    skip_mother,
                    }) do

    # don't update father,
    # recurse on to mother
    {updated_ancestors,
      id_a,
      skip,
      skip_father,
      skip_mother,
    }
  end
  def update_father({updating_ancestors,
                    id_a,
                    skip,
                    false = skip_father,
                    skip_mother,
                    }) do
# temp for now, need to fill in
updated_ancestors = updating_ancestors
    # continue on to mother
    {updated_ancestors,
      id_a,
      skip,
      skip_father,
      skip_mother,
    }
  end

###############

  def update_mother({updated_ancestors,
                    _id_a,
                    true = _skip,
                    _skip_father,
                    _skip_mother,
                    }) do

    # don't update mother,
    # recurse on to next person
    updated_ancestors
  end
  def update_mother({updated_ancestors,
                    _id_a,
                    _skip,
                    _skip_father,
                    true = _skip_mother,
                    }) do

    # don't update mother,
    # recurse on to next person
    updated_ancestors
  end
  def update_mother({updating_ancestors,
                    id_a,
                    _skip,
                    _skip_father,
                    false = _skip_mother,
                    }) do
# temp for now, need to fill in
updated_ancestors = updating_ancestors
    # recurse on to next person
    updated_ancestors
  end

end
