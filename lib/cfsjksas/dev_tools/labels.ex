defmodule Cfsjksas.DevTools.Labels do
  @moduledoc """
  make labels (filename, page title) for each person
  """

  require IEx

  def make() do
    ancestors = Cfsjksas.Chart.AgentStores.get_ancestors()
    id_a_s = Cfsjksas.Chart.AgentStores.all_a_ids()
    make(ancestors, id_a_s)
  end
  def make(ancestors, []) do
    # did everyone so
    # write temp file of this data
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/people_try1_ex.txt")
    ancestors
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(filepath)
    IO.inspect(filepath, label: "wrote ")
  end
  def make(ancestors, [id_a | rest_id_a_s]) do
    # modify id_a person to add label
    person_a = Cfsjksas.Chart.AgentStores.get_person_a(id_a)
    # label is of form gen2.MM.Ida_A_Hurlburt
    name = person_a.given_name
          <> "_" <> cond do
            is_nil(person_a.surname) ->
              "Unknown"
            true ->
              person_a.surname
          end
    |> String.replace(" ", "_")
    # need to find "best" relation (if multiple) to base gen and relation on
IO.inspect(id_a)
    label = relation_label(person_a.relation_list) <> "." <> name
IO.inspect(label)
# need to add stuff to update ancestors
    new_ancestors = put_in(ancestors, [id_a, :label], label)
    # iterate to next
    make(new_ancestors, rest_id_a_s)
  end

  def relation_label([]) do
    # CFS principal (note won't actually use this since principals special cases)
    "gen0."
  end
  def relation_label(nil) do
    IEx.pry()
  end
  def relation_label(relation_list)
      when length(relation_list) == 1 do
    relation = List.first(relation_list)
    gen = length(relation)

    "gen" <> to_string(gen) <> "." <> Enum.join(relation, "")
  end
  def relation_label(relation_list) do
    # pick "best" first by only using shortest,
    # and break any ties with sort
    best_relation = filter_relations(relation_list)
    gen = length(best_relation)
    "gen" <> to_string(gen) <> "." <> Enum.join(best_relation, "")
  end

  defp filter_relations([first_relation | rest_relations]) do
    # initiaze comparison with first relation
    filter_relations(first_relation, rest_relations)
  end
  defp filter_relations(relation, []) do
    # done comparing, return best
    relation
  end
  defp filter_relations(relation, [next | rest]) do
    # pick between relation and next
    new_winner = cond do
      length(relation) < length(next) ->
        # relation shorter so relation wins
        relation
      length(relation) > length(next) ->
        # relation longer so next wins
        next
      length(relation) == length(next) ->
        #need to sort
        [relation, next]
        |> Enum.sort()
        |> List.first()
    end
    # iterate
    filter_relations(new_winner, rest)
  end



end
