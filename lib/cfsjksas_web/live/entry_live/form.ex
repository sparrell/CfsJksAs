defmodule CfsjksasWeb.EntryLive.Form do
  use CfsjksasWeb, :live_view

  def entry(assigns) do
        ~H"""
      <%= if @current_step > 1 do %>
        <.button type="button" phx-click="prev_step">Back</.button>
      <% end %>

      <%= cond do %>
      <% @current_step == 1 -> %>
        <p></p>
        <.input field={@form[:id]} label="Ancestor ID" />
        <p></p>
        <.button type="submit" name="add_person[action]" value="id">Continue</.button>
      <% @current_step == 2 -> %>
        <p></p>
        <.input field={@form[:given_name]} label="Given name" />
        <.input field={@form[:surname]} label="Surname" />
        <p></p>
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 3 -> %>
        <p></p>
        <.input field={@form[:gender]} type="select"
          options={[{"Male", :male}, {"Female", :female}]} />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 4 -> %>
        need to do
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% true -> %>
        need to do
        <.button type="submit" name="add_person[action]" value="finish">Finish</.button>

      <% end %>

    """
  end
end
