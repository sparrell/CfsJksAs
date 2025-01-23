defmodule Cfsjksas.Circle.RefCircles do
  @moduledoc """
  routines for creating reference SVG Circle Chart
  """

  @spec make(binary()) :: binary()
  def make(svg) do
    # return modified svg and unmodified ancestors
    svg
    #<> make_cir("3000", "black")
    #<> make_cir("2500", "purple")
    #<> make_cir("3900", "blue")
    #<> make_cir("4000", "green")
    #<> make_cir("4200", "yellow")
    #<> make_cir("4400", "orange")
    #<> make_cir("4600", "red")
    #<> make_cir("4800", "black")
    #<> make_cir("5000", "purple")
    #<> make_cir("5200", "blue")
    #<> make_cir("5400", "green"),
    #<> make_cir("7500", "red")
    #<> make_cir("10000", "orange")
    #<> make_cir("11000", "red")
    #<> make_cir("12000", "black")
    #<> make_cir("13000", "purple")
    #<> make_cir("14000", "blue")
    #<> make_cir("15000", "green")
    #<> make_cir("16000", "yellow")
    #<> make_cir("17000", "orange")
    #<> make_cir("18000", "red")
    #<> make_cir("19000", "black")
    #<> make_cir("20000", "purple")
    <> make_cir("21000", "blue")
    #<> make_cir("23000", "green")
    #<> make_cir("25000", "yellow")
    #<> make_cir("27000", "orange")
    #<> make_cir("29000", "red")
    #<> make_cir("31000", "black")
    #<> make_cir("33000", "purple")
  end

  def make_cir(r, color) do
    {cxn, cyn} = Cfsjksas.Circle.Get.center()
    cx = "\"" <> to_string(cxn) <> "\""
    cy = "\"" <> to_string(cyn) <> "\""
    "<circle cx=" <> cx <> " cy=" <> cy
    <> " r=\"" <> r <> "\" stroke=\"" <> color
    <> "\" stroke-width=\"50\" fill=\"none\"/>\n"
  end

end
