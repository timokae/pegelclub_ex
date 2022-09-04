defmodule PegelclubExWeb.PlayerView do
  use PegelclubExWeb, :view

  alias PegelclubEx.Game.Player

  def player_type(%Player{guest: is_guest}) do
    if is_guest do
      "Gast"
    else
      "Stammspieler"
    end
  end
end
