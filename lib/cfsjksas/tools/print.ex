defmodule Cfsjksas.Tools.Print do
  @doc """
  pretty print elixir data
  """
  require IEx

  def write_file(outtext, filename) do
    # swap order so can use in pipes
#    IO.inspect(filename, label: "filename")
    :ok = File.write(filename, outtext)
  end

  def format_ancestor_map(ancestors_in) do
    # pretty print temp file with ancestor map
    ## people are in sorted surname/given_name order
    ## person keys are in alphabetical order
    all_people = Enum.sort_by(Map.keys(ancestors_in), & {ancestors_in[&1].surname, ancestors_in[&1].given_name, ancestors_in[&1].id})
    format_ancestor_map("%{\n", ancestors_in, all_people) <> "}\n"
  end
  def format_ancestor_map(ancestors_out, _ancestors_in, []) do
    # list emtpy, so done
    ancestors_out
  end
  def format_ancestor_map(ancestors_out, ancestors_in, [id | rest]) do
    # print person by alphabetized key
    ancestors_out
    <> "\t\t##############  " <> to_string(ancestors_in[id].given_name) <> " " <> to_string(ancestors_in[id].surname) <> "\n"
    <> "\t\t" <> to_string(id) <> ": %{\n"
    <> print_person(ancestors_in[id])
    <> "\t\t},\n"
    # recurse
    |> format_ancestor_map(ancestors_in, rest)
  end

  def print_marked_lineages() do
    Cfsjksas.Tools.Relation.make_lineages()
    |> Cfsjksas.Tools.Relation.make_sector_lineages()
    |> Cfsjksas.Tools.Relation.mark_lineages()
    |> marked_print()
  end

  def marked_print(marked) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/marked_ex.txt")

    # sort the keys
    id_m_s = Map.keys(marked)
    |> Enum.sort()

    # format the text
    outtext = marked_print("%{\n", marked, id_m_s)
    <> "}\n"

    # write the file
    write_file(outtext, filepath)
  end

  def marked_sectors_print(marked_sectors) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/marked_sectors_ex.txt")

    # sort the keys
    id_m_s = Map.keys(marked_sectors)
    |> Enum.sort()

    # format the text
    outtext = marked_print("%{\n", marked_sectors, id_m_s)
    <> "}\n"

    # write the file
    write_file(outtext, filepath)

  end

  def lines_to_file(lines) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/lines_to_id_a_ex.txt")

    lines
    |> Cfsjksas.Tools.LineSort.make_sorted_text()
    |> write_file(filepath)
  end

  def id_a_to_lines_to_file(id_a_to_lines) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/id_a_to_lines_ex.txt")

    id_a_to_lines
    |> Map.to_list()
    |> Enum.sort()
    |> inspect(pretty: true, limit: :infinity, printable_limit: :infinity)
    |> write_file(filepath)

  end

  defp print_person(person) do
    # print raw person struct, but do keys alphabetically

    # convert from struct to map so can access dynamically
    #person_map = Map.from_struct(person)
    person_map = person
    keys = Enum.sort(Map.keys(person_map))
    print_person("", keys, person_map)
  end
  defp print_person(text, [], _person) do
    # list done so return final text
    text
  end
  defp print_person(text, [this | rest], person) do
    # print this key added to previous text
    ## recurse the print if list or map
    text_to_add = cond do
      is_list(person[this]) ->
        sorted = Enum.sort(person[this])
        text1 = text <> "\t\t\t" <> to_string(this) <> ": [\n"

        text2 = Enum.reduce(sorted, text1, fn item, acc ->
          new_piece = "\t\t\t\t" <> inspect(item) <> ",\n"
          acc <> new_piece
        end)
        text2 <> "\t\t\t],\n"
      is_map(person[this]) ->
        keys = Enum.sort(Map.keys(person[this]))
        text1 = text <> "\t\t\t" <> to_string(this) <> ": %{\n"
        text2 = Enum.reduce(keys, text1, fn key, acc ->
          new_piece = "\t\t\t\t"
            <> to_string(key) <> ": "
            <> inspect(person[this][key])
            <> ",\n"
          acc <> new_piece
        end)
        text2 <> "\t\t\t},\n"
      true ->
        text <> "\t\t\t" <> to_string(this) <> ": " <> inspect(person[this], pretty: true, limit: :infinity) <> ",\n"
    end

    print_person(text_to_add, rest, person)
  end

  defp marked_print(input, _marked, []) do
    # no more id's so done
    input
  end
  defp marked_print(input, marked, [id_m | rest_id]) do
    # get person_m keys
    person = marked[id_m]

    keys = Map.keys(person)
    |> Enum.sort()

    input
    <> "\t" <> inspect(id_m) <> " => %{\n"
    <> person_m_print("", person, keys)
    <> "\t}\n"
    # pipe to recurse to next person
    |> marked_print(marked, rest_id)
  end

  defp person_m_print(input_text, _person, []) do
    # no more keys so done
    input_text
  end
  defp person_m_print(input_text, person, [key | rest_keys]) do
    input_text
    <> "      " <> to_string(key) <> ": " <> inspect(person[key]) <> ",\n"
    # and recurse to next key with above text as input
    |> person_m_print(person, rest_keys)
  end

  def relations_print(relations) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/data/relations_ex.txt")

    # sort the keys
    id_r_s = Map.keys(relations)
    |> Enum.sort(fn left, right -> compare_relations(left, right) end)
    # format the text
    outtext = relations_print("%{\n", relations, id_r_s)
    <> "}\n"

    # write the file
    write_file(outtext, filepath)

  end

  defp relations_print(prev_text, _relations, []) do
    # done
    prev_text
  end
  defp relations_print(prev_text, relations, [this | rest]) do
    prev_text <> "\t" <> inspect(relations[this]) <> ",\n"
    |> relations_print(relations, rest)
  end

  defp compare_relations(a, b) do
    la = length(a)
    lb = length(b)
    cond do
      la < lb -> true
      la > lb -> false
      true -> lex_compare(a, b)
    end
  end

  defp lex_compare([], []), do: false
  defp lex_compare([h1 | t1], [h2 | t2]) do
    case {h1,h2} do
      {"P", "P"} ->
        lex_compare(t1, t2)
      {"P", "M"} ->
        true
      {"M", "P"} ->
        false
      {"M", "M"} ->
        lex_compare(t1, t2)
      {_,_} ->
        IEx.pry()
    end
  end

end
