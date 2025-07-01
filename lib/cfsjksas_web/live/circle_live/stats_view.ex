defmodule CfsjksasWeb.CircleLive.StatsView do
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Statistics

    {has_ships, wo_ships, brickwalls_both,
      brickwalls_mother, brickwalls_father,
      _parents, normal
      } = Cfsjksas.Ancestors.Person.categorize()

    quantity_total_people = length(Cfsjksas.Ancestors.GetAncestors.all_ids())
    quantity_total_ancestors = length(Cfsjksas.Ancestors.GetRelations.all_ancestor_keys())

    quanity_has_ships = length(has_ships)
    quanity_wo_ships = length(wo_ships)
    quanity_brickwalls_both = length(brickwalls_both)
    quanity_brickwalls_mother = length(brickwalls_mother)
    quanity_brickwalls_father = length(brickwalls_father)
    quanity_brickwalls = quanity_brickwalls_both + quanity_brickwalls_mother + quanity_brickwalls_father
    quanity_normal = length(normal)

    # get the list of ids surnames
    surnames = Cfsjksas.Ancestors.Person.surnames()
    quanity_surnames = length(surnames)

    # get list of ancestors per generation
    gen_num = for gen <- 1..15, do: {gen, length(Cfsjksas.Ancestors.GetRelations.person_list(gen))}

    {:ok,
     socket
     |> assign(:quantity_total_people, quantity_total_people)
     |> assign(:quantity_total_ancestors, quantity_total_ancestors)
     |> assign(:quanity_has_ships, quanity_has_ships)
     |> assign(:quanity_wo_ships, quanity_wo_ships)
     |> assign(:quanity_brickwalls, quanity_brickwalls)
     |> assign(:quanity_normal, quanity_normal)
     |> assign(:quanity_surnames, quanity_surnames)
     |> assign(:gen_num, gen_num)
    }
  end

end
