defmodule Cfsjksas.Circle.Geprint do
  @doc """
  pretty print elixir data
  """
  require IEx

  def format_output(ancestors, :ancestors) do
    inspect(ancestors, pretty: true, limit: :infinite)
  end

  def write_file(outtext, filename) do
    File.write(filename, outtext)
  end

  def print_person(person) do
    # print raw person struct, but do keys alphabetically

    # convert from struct to map so can access dynamically
    person_map = Map.from_struct(person)
    keys = Map.keys(person_map)
    keys = Enum.sort(keys)
    print_person("", keys, person_map)
  end
  def print_person(text, [], _person) do
    # list done so return final text
    text
  end
  def print_person(text, [this | rest], person) do
    new = text <> "\t\t\t" <> inspect(this, pretty: true, limit: :infinity) <> ": " <> inspect(person[this], pretty: true, limit: :infinity) <> "\n"
    print_person(new, rest, person)
  end

end
