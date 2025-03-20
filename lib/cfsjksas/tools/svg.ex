defmodule Cfsjksas.Tools.Svg do
  # helper svg routines
  require DateTime

  def beg() do
    # svg header
    {x_num,y_num} = Cfsjksas.Circle.Get.viewbox()
    x = to_string(x_num)
    y = to_string(y_num)
    "<svg viewBox=\"0 0 " <> to_string(x) <> " " <> to_string(y)
      <> "\" xmlns=\"http://www.w3.org/2000/svg\">\n"
  end

  def trailer(svg) do
    # svg trailer
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

  def comment(text) do
    # svg comment
    "\n<!-- " <> text <> " -->"
  end

  def person_comment(person) do
    # svg comment about person
    comment(Cfsjksas.Tools.Person.person_name(person))
  end

  def xy_from_polar(radius, radians) do
    {x_center, y_center} = Cfsjksas.Create.Get.center()
    x = x_center + ( Complex.from_polar(radius, radians) |> Complex.real() |> round() )
    # recall y is positive is down not up in svg
    y = y_center - ( Complex.from_polar(radius, radians) |> Complex.imag() |> round() )
    {x,y}
  end

end
