defmodule PegelclubExWeb.ScoreComponent do
  use Phoenix.LiveComponent

  import PegelclubExWeb.Helpers

  alias PegelclubExWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <tr>
      <td class="has-text-centered"><%= player_symbol(@score) %></td>
      <td style="white-space: nowrap;">
        <%= live_patch @score.player.name, to: Routes.match_score_path(@socket, :edit, 7, @score) %>
        <%= pudel_king_symbol(@score, Map.get(@match_stats, :pudel_king_value)) %>
      </td>
      <td class="has-text-right hideable-table-col">
        <%= @score.penalty_pudel %>
      </td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_25 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_50 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_75 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_100 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_125 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_150 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_175 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.penalty_500 %></td>
      <td class="has-text-right hideable-table-col"><%= @score.delay %></td>
      <td class="has-text-right hideable-table-col"><%= @score.early_leave %></td>
      <td class="has-text-right hideable-table-col"><%= @score.other %></td>
      <td class="has-text-right hideable-table-col">
        <%= currency_format PegelclubEx.Game.penalty_sum(@score, @match_stats[:pudel_king_value]) %>
      </td>
      <td class="has-text-right">
        <%= if @match_stats[:score_totals][@score.id] do %>
          <%= currency_format @match_stats[:score_totals][@score.id] %>
        <% else %>
          <%= currency_format Map.get(@match_stats, :average) %>
        <% end %>
      </td>
    </tr>
    """
  end

  defp player_symbol(score) do
    if score.is_present do
      if score.player.guest do
        "🔹"
      else
        "🟢"
      end
    else
      "🔴"
    end
  end

  defp pudel_king_symbol(score, pudel_king_value) do
    if score.penalty_pudel == pudel_king_value do
      "👑"
    else
      ""
    end
  end
end
