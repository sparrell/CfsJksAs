defmodule Cfsjksas.Tools.Print do
  @doc """
  pretty print elixir data
  """
  require IEx

  def write_file(outtext, filename) do
    # swap order so can use in pipes
    File.write(filename, outtext)
  end

  def print_person(person) do
    # print raw person struct, but do keys alphabetically

    # convert from struct to map so can access dynamically
    #person_map = Map.from_struct(person)
    person_map = person
    keys = Map.keys(person_map)
    keys = Enum.sort(keys)
    print_person("", keys, person_map)
  end
  def print_person(text, [], _person) do
    # list done so return final text
    text
  end
  def print_person(text, [this | rest], person) do
    #new = text <> "\t\t\t" <> inspect(this, pretty: true, limit: :infinity) <> ": " <> inspect(person[this], pretty: true, limit: :infinity) <> "\n"
    new = text <> "\t\t\t" <> to_string(this) <> ": " <> inspect(person[this], pretty: true, limit: :infinity) <> ",\n"
    print_person(new, rest, person)
  end

  def format_ancestor_map(ancestors_in) do
    # pretty print temp file with ancestor map
    ## people are in sorted surname/given_name order
    ## person keys are in alphabetical order
    all_people = Enum.sort_by(Map.keys(ancestors_in), & {ancestors_in[&1].surname, ancestors_in[&1].given_name})
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


end
