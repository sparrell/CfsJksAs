defmodule CfsjksasWeb.EntryLive.Display do
  use CfsjksasWeb, :live_view

  def already(assigns) do
IO.inspect(assigns, label: "CfsjksasWeb.EntryLive display_person assigns")

    ~H"""
    <h1 style="font-size: 48px; color: darkblue;">
      <%= @id %> already in
    </h1>
    <div class="display_person">
    <ul>
      <%= for key <- @person_keys do %>
        <li>
          <strong><%= key %></strong>: <%= inspect(@person[key]) %>
        </li>
      <% end %>
    </ul>
    </div>
    """
  end

end
