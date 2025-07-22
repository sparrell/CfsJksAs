defmodule Cfsjksas.Tools.Graphviz do
  @doc """
  graphviz helpers
  """
# Cfsjksas.Tools.Graphviz.line()

  def line() do
    prev_id = "I885"
    people = [
      {:m, "darkgreen", "John Leonard"},
      {:m, "darkgreen", "Joseph Leonard"},
      {:m, "darkgreen", "Joseph Leonard2"},
      {:m, "darkgreen", "Joseph Leonard3"},
      {:f, "darkgreen", "Sarah Leonard"},
      {:f, "darkgreen", "Olive Pool"},
      {:m, "darkgreen", "Peleg Standish"},
      {:f, "darkgreen", "Sally Standish"},
      {:m, "darkgreen", "Oscar Burras"},
      {:f, "darkgreen", "Delia Burras"},
      {:f, "darkgreen", "Marie Pauline Cline"},
      {:m, "darkgreen", "James Cline Quale"},
      {:m, "darkgreen", "Dan Quale"},    ]
    line(prev_id, people)
  end

  def line(_prev_id, []) do
    # done
    nil
  end
  def line(prev_id, [name | rest]) do
    {gender, color, person_name} = name
    id = "I" <> (person_name |> String.split() |> to_string())
    # Isw -> Imary [ color=red style=bold ];
    # Ijlathom [ shape="box" fillcolor="#e0e0ff" style="solid,filled" label="James Latham" ];
    # Ialatham [ shape="box" fillcolor="#ffe0e0" style="rounded,filled" label="Anne Latham" ];

    line1 = "  " <> id <> " -> " <> prev_id <> " [ color=" <> color <> " style=bold ];"
    IO.puts(line1)

    colorfill = case gender do
      :m ->
        "\"#e0e0ff\" style=\"solid,filled\" label=\"" <> person_name <> "\""
      :f ->
        "\"#ffe0e0\" style=\"rounded,filled\" label=\"" <> person_name <> "\""
    end

    line2 = "  " <> id <>  " [ shape=box fillcolor=" <> colorfill <> " ];"
    IO.puts(line2)

    line(id, rest)
  end

end
