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
        <p></p>
        <.input field={@form[:birth_date]} label="Birth Date" />
        <.input field={@form[:birth_year]} label="Birth Year" />
        <.input field={@form[:birth_place]} label="Birth Place" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 5 -> %>
        <p></p>
        <.input field={@form[:death_date]} label="Death Date" />
        <.input field={@form[:death_year]} label="Death Year" />
        <.input field={@form[:death_place]} label="Death Place" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 6 -> %>
        <p></p>
        <.input field={@form[:mother]} label="Mother" />
        <.input field={@form[:father]} label="Father" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 7 -> %>
        <p></p>
        <.input field={@form[:ship]} type="select"
          options={[{"True", true}, {"False", false}]} label="Ship?" />
        <.input field={@form[:ship_name]} label="Ship Name" />
        <.input field={@form[:ship_date]} label="Ship Date" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 8 -> %>
        <.input field={@form[:label]} label="Label" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 9 -> %>
        <.input field={@form[:geni]} label="Geni" />
        <.input field={@form[:myheritage]} label="MyHeritage" />
        <.input field={@form[:werelate]} label="WeRelate" />
        <.input field={@form[:wikitree]} label="WikiTree" />
        <.button type="submit" name="add_person[action]" value="next">Continue</.button>
      <% @current_step == 10 -> %>
        <p>
        Validate looks good, hit Finish to store
        </p>
        <.button type="submit" name="add_person[action]" value="finish">Finish</.button>

      <% end %>

    """
  end
end
