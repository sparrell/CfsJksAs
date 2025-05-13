defmodule Cfsjksas.Tools.Enhance do
  @doc """
  pretty print elixir data
  """
  require IEx

  def immigrant("ships") do
    # look for UK in birthplace and US in deathplace
    all_people = Cfsjksas.Ancestors.GetPeople.all_people_keys()
    search(%{}, all_people)
    |> Cfsjksas.Tools.Print.format_ancestor_map()
    |> Cfsjksas.Tools.Print.write_file(Path.join(:code.priv_dir(:cfsjksas), "static/images/ancestors_temp.txt"))
  end
  def immigrant(_key) do
    # key is just so don't run accidently
    IO.inspect("wrong key, did you mean to run?")
  end
  def immigrant() do
    # key is just so don't run accidently
    IO.inspect("wrong key, did you mean to run?")
  end


  def search(out, []) do
    # done
    out
  end
  def search(out, [id | rest]) do
    # look for UK in birthplace and US in deathplace
    person = Cfsjksas.Ancestors.GetPeople.person(id)
    # skip people that have ship key
    ship = Map.get(person, :ship, nil)
    # skip people with no birthplace
    birth = person.birth_place
    # skip people with no deathplace
    death = person.death_place

    out
    |> search(id, person, ship, birth, death)
    |> search(rest)
  end
  def search(ancestors, id, person, ship, _birth, _death)
      when ship != nil do
    # to reach here, ship is valid, so no need to process further
    Map.put_new(ancestors, id, person)
  end
  def search(ancestors, id, person, nil, nil, _death) do
    # to reach here, no birth_place,  so no need to process further
    Map.put_new(ancestors, id, person)
  end
  def search(ancestors, id, person, nil, _birth, nil) do
    # to reach here, no death_place,  so no need to process further
    Map.put_new(ancestors, id, person)
  end
  def search(ancestors, id, person, nil, birth, death) do
    #to reach here, musth have non-nil birth and death places
    uk_birth = String.contains?(birth, "UK")
    us_death = String.contains?(death, "US")
    if uk_birth and us_death do
      # immigrant so update person with nil ship
      new_person = Map.put_new(person, :ship, %{name: nil, year: nil})
      Map.put_new(ancestors, id, new_person)
    else
      # not immigrant so don't update
      Map.put_new(ancestors, id, person)
    end
  end


end
