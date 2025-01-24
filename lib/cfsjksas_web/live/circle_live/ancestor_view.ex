defmodule CfsjksasWeb.CircleLive.AncestorView do
  require DateTime
  use CfsjksasWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do

    svg_path = Cfsjksas.Circle.Get.path(:ancestors_svg)
    anc_ids_path = Cfsjksas.Circle.Get.path(:ancestors_ids)
    anc_rel_path = Cfsjksas.Circle.Get.path(:ancestors_relations)
    IO.inspect(anc_rel_path, label: "anc_rel_path")
    #dir = File.cwd!
    #IO.inspect(dir, label: "dir")
    exists = File.exists?(anc_rel_path)
    IO.inspect(exists, label: "exists")
    lsdir = File.ls("/app/lib/cfsjksas-0.1.0/priv/")
    IO.inspect(lsdir, label: "lsdir")
    lsdir2 = File.ls("/app/lib/cfsjksas-0.1.0/priv/static")
    IO.inspect(lsdir2, label: "lsdir2")
    lsdir3 = File.ls("/app/lib/cfsjksas-0.1.0/priv/static/gendata")
    IO.inspect(lsdir3, label: "lsdir3")
    IO.inspect("beyond lsdir3")

    # read in ancestor_rel map
    ## read in g.ex.txt file
    {:ok, raw_rel_text} = File.read(anc_rel_path)

    IO.inspect("does it get beyond reading?")
    ## parse into elixir data
    {ancestors_relations, _bindings} = Code.eval_string(raw_rel_text)
    IO.inspect("does it get beyond parsing?")

    gen_num = for gen <- 1..15, do: {gen, length(Map.keys(ancestors_relations[gen]))}
    total_anc = sum_anc(gen_num)
    IO.inspect("does it get beyond counting ancestors?")

    # read in ancestor_ids map
    ## read in g.ex.txt file
    {:ok, raw_ids_text} = File.read(anc_ids_path)
    ## parse into elixir data
    {ancestors_ids, _bindings} = Code.eval_string(raw_ids_text)

    # find if svg file exists. Use mod time if it does
    circle_made = find_circle_made(svg_path)

    IO.inspect("does it get beyond circlemade?")

    {:ok,
     socket
     |> assign(:circle_svg, svg_path)
     |> assign(:anc_ids_path, anc_ids_path)
     |> assign(:anc_rel_path, anc_rel_path)
     |> assign(:ancestors_relations, ancestors_relations)
     |> assign(:ancestors_ids, ancestors_ids)
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
