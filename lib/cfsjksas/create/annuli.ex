defmodule Cfsjksas.Create.Annuli do
  @moduledoc """
  routines for creating SVG Anuli Chart
  """
  require IEx

  @doc """
  Input: ancestor matrix map
  Output: svg text for nnuli diagram
  """
  def make_annuli(chart, filename) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)
    case chart in [:annuli_base, :annuli_ship, :annuli_dups, :annuli_wo_dups] do
      false ->
        IEx.pry()
      true ->
        IO.inspect("made it to Create.Annuli.make_annuli")
      end

    # create matrix and fill it
    Cfsjksas.Tools.Matrix.init_ancestors()
    |> process(chart)
    |> draw(chart)
    |> Cfsjksas.Tools.GenPrint.write_file(filepath)

    IO.inspect(filepath, label: "created chart")
  end

  def process(matrix, :annuli_base) do
    # no enhancement for base
    matrix
  end
  def process(matrix, :annuli_wo_dups) do
    # enchance matrix based on chart and data in matrix
    # no op for now
    matrix
  end

  def draw(matrix, chart) do
    # do gen 0 special
    gen_list = Enum.to_list(0..14)

    Cfsjksas.Tools.Svg.beg()
    |> Cfsjksas.Annuli.Draw.ref_circle()
#    |> draw(matrix, gen_list, chart)
    |> Cfsjksas.Tools.Svg.trailer()
end



end
