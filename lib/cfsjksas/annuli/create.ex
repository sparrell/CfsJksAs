defmodule Cfsjksas.Annuli.Create do
  @moduledoc """
  routines for creating SVG "annuli" Chart
  ie each generation is in a 'band' (or annulus) as opposed to a specific circle
  """
  require DateTime
  require IEx

  @doc """
  Input: ancestor relations map
  Output: svg diagram
  """
  def make_annuli(chart, filename) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)
    case chart in [:annuli_base, :annuli_ship, :annuli_dups, :annuli_wo_dups] do
      false ->
        IEx.pry()
      true ->
        IO.inspect("made it to Annuli.create.make_annuli")
      end

    svg_beg()
    |> Cfsjksas.Annuli.Draw.ref_circle()
    |> Cfsjksas.Annuli.Draw.gen(0, chart)
    |> Cfsjksas.Annuli.Draw.gen(1, chart)
    |> Cfsjksas.Annuli.Draw.gen(2, chart)
    |> Cfsjksas.Annuli.Draw.gen(3, chart)
    |> Cfsjksas.Annuli.Draw.gen(4, chart)
    |> Cfsjksas.Annuli.Draw.gen(5, chart)
    |> Cfsjksas.Annuli.Draw.gen(6, chart)
    |> Cfsjksas.Annuli.Draw.gen(7, chart)
    |> Cfsjksas.Annuli.Draw.gen(8, chart)
    |> Cfsjksas.Annuli.Draw.gen(9, chart)
    |> Cfsjksas.Annuli.Draw.gen(10, chart)
    |> Cfsjksas.Annuli.Draw.gen(11, chart)
    |> Cfsjksas.Annuli.Draw.gen(12, chart)
    |> Cfsjksas.Annuli.Draw.gen(13, chart)
    |> Cfsjksas.Annuli.Draw.gen(14, chart)
    |> svg_end()
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

  end

  defp svg_beg() do
    {x_num,y_num} = Cfsjksas.Annuli.Get.viewbox()
    x = to_string(x_num)
    y = to_string(y_num)

    "<svg viewBox=\"0 0 " <> x <> " " <> y <> "\" xmlns=\"http://www.w3.org/2000/svg\">\n"
  end

  defp svg_end(txt) do
    now = to_string(DateTime.utc_now())
    txt
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

end
