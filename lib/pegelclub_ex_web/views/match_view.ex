defmodule PegelclubExWeb.MatchView do
  use PegelclubExWeb, :view

  def player_symbol(score) do
    cond do
      !score.is_present ->
        "🔹"
      score.player.guest ->
        "🔴"
      !score.player.guest ->
        "🟢"
    end
  end

  def pudel_king_symbol(score, pudel_king_value) do
    if score.penalty_pudel == pudel_king_value do
      "👑"
    else
      ""
    end
  end

  def currency_format(number) do
    [:erlang.float_to_binary(number / 100, [decimals: 2]), "€"]
    |> Enum.join(" ")
  end
end
