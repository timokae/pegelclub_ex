defmodule PegelclubExWeb.MatchLive do
  use PegelclubExWeb, :live_view

  alias PegelclubEx.{Game, Repo}

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Game.subscribe_to_scores(id)

    match = Game.get_match!(id)
    |> Repo.preload(scores: :player)

    scores = Game.match_scores_sorted_by_name(match)
    stats = Game.match_stats(match)

    {:ok, assign(socket, match: match, scores: scores, match_stats: stats)}
  end

  def handle_info({:score_updated, score}, socket) do
    score = Repo.preload(score, [:player, :match])


    socket = socket
      |> update(:scores, fn scores -> Enum.map(scores, fn s -> if s.id == score.id, do: score, else: s end) end)
      |> update(:match_stats, fn _ -> Game.match_stats(score.match) end)

    {:noreply, socket}
  end

  def handle_info(_, socket), do: {:noreply, socket}
end
