defmodule PegelclubExWeb.ScoreView do
  use PegelclubExWeb, :view

  def guest_select_options(players) do
    players
    |> Enum.map(fn p -> [key: p.name, value: p.id] end)
  end
end
