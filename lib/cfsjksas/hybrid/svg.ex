defmodule Cfsjksas.Hybrid.Svg do

  require DateTime

  def save_file(svgtext, filename) do
    filepath = Path.join(:code.priv_dir(:cfsjksas), "static/images/" <> filename)
    File.write(filepath, svgtext)
  end

  def beg() do
    "<svg "
    <> Cfsjksas.Hybrid.Get.size()
    <> Cfsjksas.Hybrid.Get.viewbox()
    <>" xmlns=\"http://www.w3.org/2000/svg\">"
  end

  def finish(svg) do
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end



end
