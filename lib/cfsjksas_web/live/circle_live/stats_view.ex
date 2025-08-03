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
    quantity_total_ancestors = length(Cfsjksas.Ancestors.GetLineages.all_ancestor_keys())

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
    gen_num = for gen <- 1..15, do: {gen, length(Cfsjksas.Ancestors.GetLineages.person_list(gen))}

    # get stats on completion of goal
    {_relations, ancestors, _processed_a_id_list} = Cfsjksas.Tools.Transform.dup_lineage()

    %{ship: ship, no_ship: no_ship, brickwall: brickwall} =
      Cfsjksas.Ancestors.LineEnd.classify(ancestors)
    ship_percent = to_percent_string(ship)
    no_ship_percent = to_percent_string(no_ship)
    brickwall_percent = to_percent_string(brickwall)

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
     |> assign(:ship_percent, ship_percent)
     |> assign(:no_ship_percent, no_ship_percent)
     |> assign(:brickwall_percent, brickwall_percent)
    }
  end

  def to_percent_string(number) when is_number(number) do
    # Multiply by 100 to convert to percent
    percent_value = number * 100
    # Format with one decimal place
    formatted = :io_lib.format("~.1f", [percent_value]) |> List.to_string()
    # Append percent symbol
    formatted <> "%"
  end

end
