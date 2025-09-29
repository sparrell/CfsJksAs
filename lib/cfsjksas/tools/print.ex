defmodule Cfsjksas.Tools.Print do
  @doc """
  pretty print elixir data
  """
  require IEx

  def write_file(outtext, filename) do
    # swap order so can use in pipes
    IO.inspect(filename, label: "filename")
    result = File.write(filename, outtext)
    IO.inspect(result, label: "result from writing file")
  end

  def print_person(person) do
    # print raw person struct, but do keys alphabetically

    # convert from struct to map so can access dynamically
    #person_map = Map.from_struct(person)
    person_map = person
    keys = Enum.sort(Map.keys(person_map))
    print_person("", keys, person_map)
  end
  def print_person(text, [], _person) do
    # list done so return final text
    text
  end
  def print_person(text, [this | rest], person) do
# following is what was there
#    new = text <> "\t\t\t" <> inspect(this) <> ": " <> inspect(person[this], pretty: true, limit: :infinity) <> ",\n"

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

    #print_person(new, rest, person)
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

  defp marked_print(marked) do
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
    <> "      " <> inspect(key) <> ": " <> inspect(person[key]) <> ",\n"
    # and recurse to next key with above text as input
    |> person_m_print(person, rest_keys)
  end



end
