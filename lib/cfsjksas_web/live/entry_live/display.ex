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

    <.button type="button" phx-click="prev_step">Back</.button>

    """
  end

  def entered(assigns) do
    ~H"""
    <div class="entered">
      <h1 style="font-size: 48px; color: darkblue;">Enter Person Data</h1>
      <p>
        Current Step: <%= @current_step %>
      </p>

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
                Surname: <strong><%= @new_person.surname %></strong>
              </li>
      <% end %>

      <%= if @current_step > 3 do %>
              <li>
                Gender: <strong><%= @new_person.gender %></strong>
              </li>
      <% end %>

      <%= if @current_step > 4 do %>
              <li>
                Birth Date: <strong><%= @new_person.birth_date %></strong>
              </li>
              <li>
                Birth Year: <strong><%= @new_person.birth_year %></strong>
              </li>
              <li>
                Birth Place: <strong><%= @new_person.birth_place %></strong>
              </li>
      <% end %>

      <%= if @current_step > 5 do %>
              <li>
                Death Date: <strong><%= @new_person.death_date %></strong>
              </li>
              <li>
                Death Year: <strong><%= @new_person.death_year %></strong>
              </li>
              <li>
                Death Place: <strong><%= @new_person.death_place %></strong>
              </li>
      <% end %>

      <%= if @current_step > 6 do %>
              <li>
                Mother: <strong><%= @new_person.mother %></strong>
              </li>
              <li>
                Father: <strong><%= @new_person.father %></strong>
              </li>
              <li>
                Children: <strong><%= @children %></strong>
              </li>
      <% end %>

      <%= if @current_step > 7 do %>
              <li>
                Ship: <strong><%= @new_person.ship? %></strong>
              </li>
              <li>
                Ship Name: <strong><%= @new_person.ship_name %></strong>
              </li>
              <li>
                Ship Date: <strong><%= @new_person.ship_date %></strong>
              </li>
      <% end %>

      <%= if @current_step > 8 do %>
              <li>
                Label: <strong><%= @new_person.label %></strong>
              </li>
      <% end %>

    </ul>

    </div>

    """
  end

end
