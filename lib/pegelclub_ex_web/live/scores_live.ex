defmodule PegelclubExWeb.ScoresLive do
  use PegelclubExWeb, :live_view

  alias PegelclubEx.Game

  def render(assigns) do
    ~H"""
    At: <%= @time %>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Game.subscribe_to_scores()

    time = DateTime.utc_now()
    # match = Game.get_match!(match_id)
    {:ok, assign(socket, time: time)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    time = DateTime.utc_now()
    {:noreply, assign(socket, :time, time )}
  end
end
