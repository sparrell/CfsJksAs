defmodule Cfsjksas.Chart.Svg do

  require DateTime

  def save_file(svgtext, filename) do
    filepath = Cfsjksas.Chart.Get.path(filename)
    File.write(filepath, svgtext)
    test_filepath = filepath <> ".txt"
    File.write(test_filepath, svgtext)
  end

  def beg() do
    cfg = Cfsjksas.Chart.Get.config().svg
    "<svg "
    <> cfg.size
    <> cfg.viewbox
    <>" xmlns=\"http://www.w3.org/2000/svg\">"
  end

  def finish(svg) do
    now = to_string(DateTime.utc_now())
    svg
    <> "\n<!-- made new svg at " <> now <> " -->"
    <> "\n</svg>"
  end

end
