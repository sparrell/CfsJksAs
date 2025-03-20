defmodule Cfsjksas.Tools.Matrix do
  # make and use a matrix of all sectors for all generations
  def initialize() do
    # make a generation map of sector maps
    ## ignore gen zero as special case

    # recurse thru 14 generations
    initialize(%{}, Enum.to_list(1..14))
  end
  defp initialize(matrix, []) do
    # no more generations, so return
    matrix
  end
  defp initialize(matrix, [this_gen | rest_gen]) do
    # add this_gen of sectors to input_map

    # make list of sectors in this gen
    num_sectors = 2 ** this_gen
    sector_list = Enum.to_list(0..(num_sectors-1))

    # add this gen's sectors and recurse
    initialize(matrix, this_gen, sector_list)
    |> initialize(rest_gen)

  end
  defp initialize(matrix, _this_gen, []) do
    # no more for this gen, so return
    matrix
  end
  defp initialize(matrix, this_gen, [this_sector | rest_sectors]) do
    # add this_sector to sector_map and iterate thru rest of sectors
    Map.put(matrix, {this_gen, this_sector}, nil)
    |> initialize(this_gen, rest_sectors)
  end

  def init_ancestors() do
    gen_list = Cfsjksas.Ancestors.GetRelations.genlist()
    initialize()
    |> add_ancestors(gen_list)
  end

  defp add_ancestors(matrix, []) do
    # no generations left so matrix is initialized
    matrix
  end
  defp add_ancestors(matrix, [0 | rest_gen]) do
    # gen zero is special case
    # recurse on to rest
    add_ancestors(matrix, rest_gen)
  end
  defp add_ancestors(matrix, [this_gen | rest_gen]) do
    # update matrix for each gneration, updatkng for each person in each generation
    matrix
    |> add_ancestors(this_gen, Cfsjksas.Ancestors.GetRelations.person_list(this_gen)) # this gen ancestors
    |> add_ancestors(rest_gen) # recurse
  end
  defp add_ancestors(matrix, _this_gen, []) do
    # no more ancestors in this generation, return
    matrix
  end
  defp add_ancestors(matrix, this_gen, [this_ancestor | rest_ancestors] ) do
    # add this ancestor to matrix
    # this_ancestor is relations key
    person = Cfsjksas.Ancestors.GetRelations.data(this_gen,this_ancestor)

    # this_ancestor.sector is sector number for this ancestor
    ## {this_gen, sector} is key for matrix entry

    # recurse thru rest of ancestors in this generation, putting in each ancestor in a section
    Map.put(matrix, {this_gen, person.sector}, person)
    |> add_ancestors(this_gen, rest_ancestors)
  end

end
