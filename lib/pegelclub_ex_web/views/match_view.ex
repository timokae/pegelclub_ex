defmodule PegelclubExWeb.MatchView do
  use PegelclubExWeb, :view

  def player_symbol(score) do
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

  def pudel_king_symbol(score, pudel_king_value) do
    if score.penalty_pudel == pudel_king_value do
      "👑"
    else
      ""
    end
  end
end
