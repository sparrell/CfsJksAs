defmodule CfsjksasWeb.EntryLive.Display do
  use CfsjksasWeb, :live_view

  def already(assigns) do
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

  def entered(assigns) do
    ~H"""
    <div class="entered">
      <h1 style="font-size: 48px; color: darkblue;">Enter Person Data</h1>
      <ul>

      <%= if @current_step > 1 do %>
              <li>
                ID: <strong><%= @new_person.id %></strong>
              </li>
      <% end %>

      <%= if @current_step > 2 do %>
              <li>
                Given Name: <strong><%= @new_person.given_name %></strong>
              </li>
              <li>
                Surame: <strong><%= @new_person.surname %></strong>
              </li>
      <% end %>

    fill rest of entered in later
    </ul>

    </div>

    """
  end

end
