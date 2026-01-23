defmodule Cfsjksas.DevTools.Run do
  def graphs() do
    Cfsjksas.Chart.Circle.main("circle.svg")
    Cfsjksas.Chart.CircleMod.main("circle_mod.svg")
  end

end
