defmodule Cfsjksas.Ancestors.LineEnd do
  @moduledoc """
  funcions for procesing line-ends ie terminations
  each person:
    endofline:
      :false
      :true
    eol_type
      :nil
      :brickwall_both
      :brickwall_mom
      :brickwall_dad
      :no_ship
      :ship

  if not end-of-line, go to next person
  if end-of-line:
    brickwall_both:
      add 1/2**n to brickwall
    brickwall_mom:
      add 1/(2**(n+1)) to brickwall
    brickwall_dad:
      add 1/(2**(n+1)) to brickwall
    no_ship:
      add 1/(2**n) to no_ship
    ship:
      add 1/(2**n) to ship
  """

  require IEx

  def classify(ancestors) do
    a_ids = Map.keys(ancestors)
    # initialize answer map
    %{
      ship: 0.0,
      no_ship: 0.0,
      brickwall: 0.0
    }
    # feed init'd map to recurse thru each person
    |> classify(ancestors, a_ids)
  end
  def classify(answer, _ancestors, []) do
    # finished last person, return answer
    answer
  end
  def classify(answer, ancestors, [this | rest]) do
    # classify person
    person = ancestors[this]
    ship = case Map.has_key?(person, :ship) do
      true ->
        case person.ship do
          :parent ->
            false # parent beyond ship so ignore
          val when is_map(val) ->
            person.ship.name
        end
      false ->
        false
    end
    # update answer based on classification
    term_class(answer, person.mother, person.father, ship, person.relation_list)
    ## then go to next person, with new answer
    |> classify(ancestors, rest)
  end

  @doc """
  term_class(prev_answer, mother, father, ship)
  returns updated answer based on classification of person
  """
  def term_class(answer, mother, father, _ship, _relation_list)
      when (mother != nil) and (father != nil) do
    # not a termination since has mother and father
    ## so return answer unchanged
    answer
  end
  def term_class(answer, _mother, _father, _ship, []) do
    # no relations left so done
    answer
  end
  def term_class(answer, nil, nil, false, relation_list) do
    # brickwall_both since no mother or father and no ship
    # for each lineage in relation_list,
    ##  add 1 / (2**gen) to brickwall
    update_brickwall_both(answer, relation_list)
  end
  def term_class(answer, nil, nil, nil, relations_list) do
    # no_ship since no mother or father and ship key exists but empty
    update_no_ship(answer, relations_list)
  end
  def term_class(answer, nil, nil, shipname, relations_list)
      when shipname != nil do
    # has ship (and no parents so is termination)
    ## note has ship and parents is not end of line ie child came with parents
    update_ship(answer, relations_list)
  end
  def term_class(answer, mother, nil, false, relations_list)
      when mother != nil do
    # has mother, no father, so half brick wall
    update_brickwall_half(answer, relations_list)
  end
  def term_class(answer, nil, father, false, relations_list)
      when father != nil do
    # has father, no mother, so half brick wall
    update_brickwall_half(answer, relations_list)
  end
  def term_class(answer, mother, father, nil, relations_list)
      when ((mother != nil) or (father != nil)) do
    # child is no_ship with one parent known and one parent unknown
    # so 'half ship' (since other half ship will get covered by one parent)
    update_no_ship_half(answer, relations_list)
  end
  def term_class(answer, mother, father, ship, relations_list)
      when ((mother != nil) or (father != nil))
      and (ship != nil) and (ship != false) do
    # child is ship with one parent known and with one parent unknown
    # so 'half ship' (since other half ship will get covered by known parent)
    update_ship_half(answer, relations_list)
  end
  def term_class(answer, mother, father, ship, relations_list) do
    # how get here?
    IEx.pry()
  end

  @doc """
  update_brickwall_both(prev_answer, relation_list)
  recurse thru lineages, adding to brick will
  """
  def update_brickwall_both(answer, []) do
    # no more lineages so done
    answer
  end
  def update_brickwall_both(answer, [this | rest]) do
    gen = length(this)
    update = 1 / (2**gen)

    # update answer:brickwall: with previous value plus update
    answer
    |> Map.update(:brickwall, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_brickwall_both(rest)
  end
  def update_brickwall_half(answer, []) do
    # no more lineages so done
    answer
  end
  def update_brickwall_half(answer, [this | rest]) do
    gen = length(this) + 1 # brickwall is of parent
    update = 1 / (2**gen)

    # update answer:brickwall: with previous value plus update
    answer
    |> Map.update(:brickwall, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_brickwall_half(rest)
  end
  def update_no_ship(answer, []) do
    # no more lineages so done
    answer
  end
  def update_no_ship(answer, [this | rest]) do
    gen = length(this)
    update = 1 / (2**gen)
    answer
    |> Map.update(:no_ship, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_no_ship(rest)
  end

  def update_no_ship_half(answer, []) do
    # no more lineages so done
    answer
  end
  def update_no_ship_half(answer, [this | rest]) do
    gen = length(this) + 1 # since this is the half not covered by parent
    update = 1 / (2**gen)
    answer
    |> Map.update(:no_ship, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_no_ship_half(rest)
  end

  def update_ship(answer, []) do
    # no more lineages so done
    answer
  end
  def update_ship(answer, [this | rest]) do
    gen = length(this)
    update = 1 / (2**gen)
    answer
    |> Map.update(:ship, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_ship(rest)
  end

  def update_ship_half(answer, []) do
    # no more lineages so done
    answer
  end
  def update_ship_half(answer, [this | rest]) do
    gen = length(this) + 1 # since known parent will handle other half
    update = 1 / (2**gen)
    answer
    |> Map.update(:ship, update, fn val -> val + update end)
    # and recurse thru rest of relation_list
    |> update_ship_half(rest)
  end

end
