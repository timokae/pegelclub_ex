defmodule PegelclubExWeb.ScoreComponent do
  use Phoenix.LiveComponent

  import PegelclubExWeb.Helpers

  alias PegelclubExWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class={"score-box box is-flex is-flex-direction-column my-0 #{if @score.has_payed, do: "has-payed"}"}>
      <header class="is-flex is-flex-direction-row is-justify-content-space-between">
        <div class="is-flex is-flex-direction-row is-align-items-center">
          <%= live_patch(
            @score.player.name,
            to: Routes.match_score_path(@socket, :edit, 7, @score),
            class: "has-text-grey-dark has-text-weight-bold mr-2"
          ) %>

          <%= if @score.has_payed do %>
            <span class="icon">
              <i class="ri-check-line ri-lg"></i>
            </span>
          <% end %>

          <%= if @score.penalty_pudel == Map.get(@match_stats, :pudel_king_value) do%>
            <span class="icon">
              <i class="ri-vip-crown-fill"></i>
            </span>
          <% end %>

          <%= if @match_stats[:score_totals][@score.id] == @match_stats.penalty_king do %>
            <span class="icon">
              <i class="ri-fire-fill"></i>
            </span>
          <% end %>

          <%= if @match_stats[:score_totals][@score.id] == @match_stats.penalty_saver do %>
            <span class="icon">
              <i class="ri-leaf-fill"></i>
            </span>
          <% end %>
        </div>

        <%= live_patch(
          to: Routes.match_score_path(@socket, :edit, 7, @score),
          class: "has-text-grey-dark has-text-weight-bold"
        ) do %>
          <button class="button is-ghost">
            <span class="icon">
              <i class="ri-edit-2-fill ri-lg"></i>
            </span>
          </button>
        <% end %>
      </header>

      <p class="is-size-7 has-text-grey"><%= player_status(@score) %></p>

      <div class="is-flex is-justify-content-space-between is-align-items-center mt-3">
        <p class="has-text-success is-size-5 has-text-weight-bold">
          <%= if @match_stats[:score_totals][@score.id] do %>
            <%= currency_format @match_stats[:score_totals][@score.id] %>
          <% else %>
            <%= currency_format(Map.get(@match_stats, :average) + PegelclubEx.Game.Scores.penalty_other(@score)) %>
          <% end %>
        </p>
        <button
          class="button is-ghost toggle-details"
          phx-click={JS.toggle(to: "##{dom_id(@score, ["score", "details"])}", in: "fade-in", out: "fade-out")}
        >
          Details
        </button>
      </div>

      <div id={dom_id(@score, ["score", "details"])} style="display: none;">
        <div class="columns is-multiline is-mobile mt-2 has-text-right">
          <div class="column is-full">
            <hr class="my-0"/>
          </div>

          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_pudel %></span>
            <span class="is-size-7 has-text-grey">x Pudel</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_25 %></span>
            <span class="is-size-7 has-text-grey">x 0.25 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_50 %></span>
            <span class="is-size-7 has-text-grey">x 0.50 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_75 %></span>
            <span class="is-size-7 has-text-grey">x 0.75 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_100 %></span>
            <span class="is-size-7 has-text-grey">x 1.00 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_125 %></span>
            <span class="is-size-7 has-text-grey">x 1.25 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_150 %></span>
            <span class="is-size-7 has-text-grey">x 1.50 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_175 %></span>
            <span class="is-size-7 has-text-grey">x 1.75 €</span>
          </div>
          <div class="column is-one-third">
            <span class="has-text-weight-bold"><%= @score.penalty_500 %></span>
            <span class="is-size-7 has-text-grey">x 5.00 €</span>
          </div>

          <div class="column is-full">
            <hr class="my-0"/>
          </div>

          <div class="column is-half" style="line-height: 100%">
            <span class="has-text-weight-bold"><%= @score.delay %></span>
            <br>
            <span class="is-size-7 has-text-grey"> Minuten Verspätung</span>
          </div>
          <div class="column is-half" style="line-height: 100%">
            <span class="has-text-weight-bold"><%= @score.early_leave %></span>
            <br>
            <span class="is-size-7 has-text-grey">Minuten zu früh gegangen </span>
          </div>
          <div class="column is-half" style="line-height: 100%">
            <span class="has-text-weight-bold"><%= @score.other %> €</span>
            <br>
            <span class="is-size-7 has-text-grey">sonstiges</span>
          </div>

          <div class="column is-full">
            <hr class="my-0"/>
          </div>

          <div class="column is-full" style="line-height: 100%;">
            <span class="has-text-weight-bold"><%= currency_format PegelclubEx.Game.penalty_sum(@score, @match_stats[:pudel_king_value]) %></span>
            <br>
            <span class="is-size-7 has-text-grey">Strafe insgesamt</span>
          </div>
        </div>
      </div>


      <footer>
      </footer>
    </div>
    """
  end

  defp player_status(score) do
    if score.is_present do
      if score.player.guest do
        # "🔹"
        "Gast"
      else
        # "🟢"
        "Anwesend"
      end
    else
      # "🔴"
      "Abwesend"
    end
  end

  defp player_symbol(score, pudel_king_value) do
    if score.penalty_pudel == pudel_king_value do
      ""
    else
      "ri-user-3-fill ri-lg"
    end
  end

  defp initials(player) do
    player.name
    |> String.at(0)
  end
end
