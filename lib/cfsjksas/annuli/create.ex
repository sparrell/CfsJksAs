defmodule Cfsjksas.Annuli.Create do
  @moduledoc """
  routines for creating SVG "annuli" Chart
  ie each generation is in a 'band' (or annulus) as opposed to a specific circle
  """
  require DateTime

  @doc """
  Input: ancestor relations map
  Output: svg diagram
  """
  def make_annuli() do
    IO.inspect("made it to create.make_annuli")
    svg_path = Cfsjksas.Annuli.Get.path(:ancestors_svg)

    svg_beg()
    |> Cfsjksas.Annuli.Draw.ref_circle()
    |> Cfsjksas.Annuli.Draw.gen(0)
    |> Cfsjksas.Annuli.Draw.gen(1)
    |> Cfsjksas.Annuli.Draw.gen(2)
    |> Cfsjksas.Annuli.Draw.gen(3)
    |> Cfsjksas.Annuli.Draw.gen(4)
    |> Cfsjksas.Annuli.Draw.gen(5)
    |> Cfsjksas.Annuli.Draw.gen(6)
    |> Cfsjksas.Annuli.Draw.gen(7)
    |> Cfsjksas.Annuli.Draw.gen(8)
    |> Cfsjksas.Annuli.Draw.gen(9)
    |> Cfsjksas.Annuli.Draw.gen(10)
    |> Cfsjksas.Annuli.Draw.gen(11)
    |> Cfsjksas.Annuli.Draw.gen(12)
    |> Cfsjksas.Annuli.Draw.gen(13)
    |> Cfsjksas.Annuli.Draw.gen(14)
    |> svg_end()
    |> Cfsjksas.Circle.Geprint.write_file(svg_path)

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
