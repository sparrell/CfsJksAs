defmodule CfsjksasWeb.CircleLive.AncestorView do
  require IEx
  require DateTime
  use CfsjksasWeb, :live_view

  @impl true
  def mount(params, _session, socket) do

    svg_path = Cfsjksas.Circle.Get.path(:ancestors)
    gtxt_path = Cfsjksas.Circle.Get.path(:ancestors_svg)

    # read in g.ex.txt file
    {:ok, inputtext} = File.read(gtxt_path)

    # read in ancestor map
    {ancestors, _bindings} = Code.eval_string(inputtext)

    gen_num = for gen <- 1..15, do: {gen, length(Map.keys(ancestors[gen]))}
    total_anc = sum_anc(gen_num)

    # find if svg file exists. Use mod time if it does
    circle_made = find_circle_made(svg_path)

    {:ok,
     socket
     |> assign(:gextxt, @gextxt)
     |> assign(:family_of_interest, :f210)
     |> assign(:source_of_interest, :s006)
     |> assign(:circle_svg, svg_path)
     |> assign(:ancestors, ancestors)
     |> assign(:circle_made, circle_made)
     |> assign(:gen_num, gen_num)
     |> assign(:total_anc, total_anc)
    }
  end

  @impl true
  def handle_event("save", _params, socket) do
    Cfsjksas.Circle.Create.main(socket.assigns.ancestors)
    {:noreply, socket}
  end

  defp find_circle_made(svg_path) do
    {file_ok, file_stats} = File.stat(svg_path, time: :local)
    find_circle_made(file_ok, file_stats)
  end
  defp find_circle_made(:ok, file_stats) do
    # file exists, return sting of modify time
    inspect(file_stats.mtime)
  end
  defp find_circle_made(_ok, _stats) do
    # bad return so say unknown
    "unknown"
  end

  defp sum_anc(gen_num) do
    # sum the total ancestors per generation
    sum_anc(gen_num, 0)
  end
  defp sum_anc([], total) do
    # since list empty, return total
    total
  end
  defp sum_anc([{_gen, this} | rest], acc) do
    # add this generation number to accumultor and recurse
    sum_anc(rest, acc + this)
  end

end
