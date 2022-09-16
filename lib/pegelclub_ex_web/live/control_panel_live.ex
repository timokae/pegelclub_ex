defmodule PegelclubExWeb.ControlPanelLive do
  use PegelclubExWeb, :live_view

  alias PegelclubEx.{Game, Repo}

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Game.subscribe_to_scores(id)

    match = Game.get_match!(id)
    scores = Game.match_scores_sorted_by_name(match)

    socket = assign(
      socket,
      match: match,
      scores: scores,
      feed_messages: [],
      selected_score: nil,
      selected_penalty: nil
    )

    {:ok, socket}
  end

  # INFO HANDLER
  def handle_info({:score_incremented, %{:score => score, :penalty => penalty}}, socket) do
    if (score.match_id != socket.assigns.match.id), do: {:noreply, socket}

    score = Repo.preload(score, :player)
    message = "#{penalty_string(penalty)} Strafe für #{score.player.name}"

    socket = update(socket, :feed_messages, fn feed_messages ->
      [ %{id: feed_message_id(score), message: message, penalty: penalty, score_id: score.id} | feed_messages ]
      |> Enum.take(5)
    end)

    {:noreply, socket}
  end

  def handle_info({:feed_message_removed, id}, socket) do
    socket = update(socket, :feed_messages, fn feed_messages ->
      Enum.filter(feed_messages, fn m -> m[:id] != id end)
    end)

    {:noreply, socket}
  end

  def handle_info(:selection_change, socket) do
    score_id = socket.assigns.selected_score
    penalty = socket.assigns.selected_penalty

    socket =
      if score_id && penalty do
        Game.get_score!(score_id)
        |> Game.increase_penalty(penalty)

        socket
        |> update(:selected_score, fn _ -> nil end)
        |> update(:selected_penalty, fn _ -> nil end)
      else
        socket
      end

      {:noreply, socket}
    end

    def handle_info(_, socket) do
      {:noreply, socket}
    end

  # EVENT HANDLER
  def handle_event("decrement", %{"message-id" => message_id, "penalty" => penalty, "score-id" => score_id}, socket) do
    score = Game.get_score!(score_id)
    Game.decrease_penalty(score, String.to_atom(penalty))

    Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "match_scores_#{score.match_id}", {:feed_message_removed, message_id})

    {:noreply, socket}
  end

  def handle_event("select-name", %{"value" => score_id}, socket) do
    socket = assign(socket, :selected_score, score_id)

    Process.send(self(), :selection_change, [])

    {:noreply, socket}
  end

  def handle_event("select-penalty", %{"value" => penalty}, socket) do
    socket = assign(socket, :selected_penalty, String.to_atom(penalty))

    Process.send(self(), :selection_change, [])

    {:noreply, socket}
  end

  # =========

  def feed_message_id(score) do
    Enum.join(["feed_message", score.id, DateTime.utc_now |> DateTime.to_unix], "_")
  end

  def penalty_string(penalty) do
    %{
      penalty_25: "0.25 €",
      penalty_50: "0.50 €",
      penalty_75: "0.75 €",
      penalty_100: "1.00 €",
      penalty_125: "1.25 €",
      penalty_150: "1.50 €",
      penalty_175: "1.75 €",
      penalty_500: "5.00 €",
      penalty_pudel: "Pudel",
    }
    |> Map.get(penalty)
  end
end
