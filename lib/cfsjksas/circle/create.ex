defmodule Cfsjksas.Circle.Create do
  @moduledoc """
  routines for creating SVG Circle Chart
  """
  require DateTime

  @doc """
  Input: ancestor relations map
  Output: svg text for circle diagram
  """
  def main(chart, filename) do
    IO.inspect("made it to create.main")
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)


    svg_beg()
    |> Cfsjksas.Circle.RefCircles.make()
    |> Cfsjksas.Circle.Draw.gen()
    |> Cfsjksas.Circle.Draw.gen(1, chart)
    |> Cfsjksas.Circle.Draw.gen(2, chart)
    |> Cfsjksas.Circle.Draw.gen(3, chart)
    |> Cfsjksas.Circle.Draw.gen(4, chart)
    |> Cfsjksas.Circle.Draw.gen(5, chart)
    |> Cfsjksas.Circle.Draw.gen(6, chart)
    |> Cfsjksas.Circle.Draw.gen(7, chart)
    |> Cfsjksas.Circle.Draw.gen(8, chart)
    |> Cfsjksas.Circle.Draw.gen(9, chart)
    |> Cfsjksas.Circle.Draw.gen(10, chart)
    |> Cfsjksas.Circle.Draw.gen(11, chart)
    |> Cfsjksas.Circle.Draw.gen(12, chart)
    |> Cfsjksas.Circle.Draw.gen(13, chart)
    |> Cfsjksas.Circle.Draw.gen(14, chart)
    |> svg_end()
    |> Cfsjksas.Circle.Geprint.write_file(filepath)

    IO.inspect(filename, label: "created chart")
  end

  defp svg_beg() do
    #<svg viewBox="0 0 10000 10000" xmlns="http://www.w3.org/2000/svg">
    {x_num,y_num} = Cfsjksas.Circle.Get.viewbox()
    x = to_string(x_num)
    y = to_string(y_num)
    "<svg viewBox=\"0 0 " <> to_string(x) <> " " <> to_string(y)
      <> "\" xmlns=\"http://www.w3.org/2000/svg\">\n"
  end

  def svg_end(svg) do
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

end
