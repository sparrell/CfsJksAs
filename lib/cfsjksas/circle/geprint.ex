defmodule Cfsjksas.Circle.Geprint do
  @doc """
  pretty print tree to .g.ex.txt file
  """

  def format_output(ancestors, :ancestors) do
    inspect(ancestors, pretty: true, limit: :infinite)
  end

  def write_file(outtext, filename) do
    File.write(filename, outtext)
  end


end
