defmodule Cfsjksas.Circle.Create do
  @moduledoc """
  routines for creating SVG Circle Chart
  """
  require DateTime

  @doc """
  Input: ancestor relations map
  Output: svg text for circle diagram
  """
  def main(ancestor_relations) do
    IO.inspect("made it to create.main")
    svg_beg()
    |> Cfsjksas.Circle.RefCircles.make()
    |> Cfsjksas.Circle.Draw.gen()
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 1)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 2)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 3)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 4)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 5)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 6)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 7)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 8)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 9)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 10)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 11)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 12)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 13)
    |> Cfsjksas.Circle.Draw.gen(ancestor_relations, 14)
    |> svg_end()
    |> Cfsjksas.Circle.Geprint.write_file(Cfsjksas.Circle.Get.path(:ancestors_svg))
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
