defmodule CfsjksasWeb.CircleLive.AncestorView do
  require DateTime
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do

    svg_path = Cfsjksas.Circle.Get.path(:ancestors_svg)
    anc_ids_path = Cfsjksas.Circle.Get.path(:ancestors_ids)
    #anc_rel_path = Cfsjksas.Circle.Get.path(:ancestors_relations)

    # read in ancestor_rel map
    ## read in g.ex.txt file
    #{:ok, raw_rel_text} = File.read(anc_rel_path)

    ## parse into elixir data
    #{ancestors_relations, _bindings} = Code.eval_string(raw_rel_text)
    ancestors_relations = Cfsjksas.Circle.GetRelations.data()

    #gen_num = for gen <- 1..15, do: {gen, length(Map.keys(ancestors_relations[gen]))}
    gen_num = for gen <- 1..15, do: {gen, length(Map.keys(Cfsjksas.Circle.GetRelations.data(gen)))}
    total_anc = sum_anc(gen_num)

    # read in ancestor_ids map
    ## read in g.ex.txt file
    {:ok, raw_ids_text} = File.read(anc_ids_path)
    ## parse into elixir data
    {ancestors_ids, _bindings} = Code.eval_string(raw_ids_text)

    # find if svg file exists. Use mod time if it does
    circle_made = find_circle_made(svg_path)

    {:ok,
     socket
     |> assign(:circle_svg, svg_path)
     |> assign(:anc_ids_path, anc_ids_path)
     |> assign(:ancestors_relations, ancestors_relations)
     |> assign(:ancestors_ids, ancestors_ids)
     |> assign(:circle_made, circle_made)
     |> assign(:gen_num, gen_num)
     |> assign(:total_anc, total_anc)
    }
  end

  @impl true
  def handle_event("save", _params, socket) do
    Cfsjksas.Circle.Create.main()
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
