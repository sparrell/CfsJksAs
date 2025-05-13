defmodule Cfsjksas.Tools.Relation do
  @doc """
  make new relations file:
     - with primary duplicate marked
     - with linked duplicate marked
     - with successive generation duplicates removed
     - with terminations marked:
        + duplicates
        + immigrant w ship
        + immigrant wo ship
        + brickwall
        + continues
  """
  require IEx

  def dedup() do
    # make new relations map starting from exiting map
    # start with a copy of existing map
    # leave generations 0,1,2 alone
    # process generations 3-14
    Cfsjksas.Ancestors.GetRelations.data()
    |> dedup([Enum.to_list(3..14)])

  end
  def dedup(relations, []) do
    # generations list empty so done
    relations
  end
  def dedup(relations, [gen | rest]) do
    this_gen_people_map = relations[gen]
    # sort relation_keys with special sort
    relation_keys = Map.keys(this_gen_people_map)
#    |> Enum.sort(&compare_relations/2)

    something = relations
    dedup(something, rest)
  end

  def compare_relations(rel1, rel2)
      when rel1 == rel2 do
    true
  end
  def compare_relations(rel1, rel2) do
    [h1 | [h2 | _tail1 ] ] = rel1
    [h3 | [h4 | _tail2 ] ] = rel2
    case {h1,h2,h3,h4} do
      {"P","P","P","P"} ->
        rel1 >= rel2
      {"P","P", _ ,_ } ->
        true
      {_, _, "P", "P"} ->
        false
      {"M","M", _, _} ->
        true
      { _, _, "M","M"} ->
        false
      _ ->
        rel1 >= rel2
    end
  end


end
