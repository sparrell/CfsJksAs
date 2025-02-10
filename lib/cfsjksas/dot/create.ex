defmodule Cfsjksas.Dot.Create do
  @moduledoc """
  routines for creating SVG graphviz Chart
  """
  require DateTime

  @doc """
  Input: ancestor relations map
  Output: svg text for graphviz twopi svg diagram
  """
  def make_dot() do
    IO.inspect("made it to create.main")
    dot_path = Cfsjksas.Dot.Get.path(:ancestors_dot)
    svg_path = Cfsjksas.Dot.Get.path(:ancestors_dot_svg)

    dot_beg()
    |> Cfsjksas.Dot.Draw.gen(0)
    |> Cfsjksas.Dot.Draw.gen(1)
    |> Cfsjksas.Dot.Draw.gen(2)
    |> Cfsjksas.Dot.Draw.gen(3)
    |> Cfsjksas.Dot.Draw.gen(4)
    |> Cfsjksas.Dot.Draw.gen(5)
    |> Cfsjksas.Dot.Draw.gen(6)
    |> Cfsjksas.Dot.Draw.gen(7)
    |> Cfsjksas.Dot.Draw.gen(8)
    |> Cfsjksas.Dot.Draw.gen(9)
    |> Cfsjksas.Dot.Draw.gen(10)
    |> Cfsjksas.Dot.Draw.gen(11)
    |> Cfsjksas.Dot.Draw.gen(12)
    |> Cfsjksas.Dot.Draw.gen(13)
    |> Cfsjksas.Dot.Draw.gen(14)
    |> dot_end()
    |> Cfsjksas.Circle.Geprint.write_file(dot_path)

    IO.inspect("making svg from dot")
    make_svg(dot_path, svg_path)

  end

  def make_svg(dot_path, svg_path) do

    out = System.cmd("dot", ["-Tsvg", dot_path, "-o", svg_path])
    IO.inspect(out, label: "svg out")
  end

  defp dot_beg() do
    "graph ancestors {\n"
    <> "labelloc=\"t\"\n"
    <> "label=\"Ancestry of Charles, Jim, Ann\"\n"
    <> "fontname=\"URW Chancery L, Apple Chancery, Comic Sans MS, cursive\"\n"
#    <> "layout=circo; graph [ranksep=1 overlap=false];\n"
#   <> "graph [ranksep=1 overlap=false];\n"
#    <> "layout=twopi; graph [ranksep=1 overlap=false];\n"
    <> "layout=neato; graph [ranksep=1 overlap=false];\n"
#   <> "layout=sfdp; graph [ranksep=1 overlap=false];\n"
    <> "edge [penwidth=1 color=\"black\"]\n"
    <> "node [style=\"filled\" penwidth=0 fillcolor=\"#f0f0ffA0\" fontcolor=indigo]\n"

  end

  defp dot_end(txt) do
    txt
    <> "c [label=\"© 2025 Duncan Sparrell\" fontsize=12 shape=plain style=\"\" fontcolor=gray]\n"
    <> "}\n"
  end

end
