defmodule PegelclubExWeb.ControlPanelLive do
  use PegelclubExWeb, :live_view

  alias PegelclubEx.{Game, Repo}

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Game.subscribe_to_scores(id)

    match = Game.get_match!(id)
    scores = Game.match_scores_sorted_by_name(match)

    feed_items = Enum.map(
      Game.ControlPanelServer.get_feed(match.id),
      fn item -> %{
        id: item.id,
        message: generate_message(item.penalty, item.score),
        penalty: item.penalty,
        score_id: item.score.id,
        created_at: item.created_at
      }
      end
    )

    socket = assign(
      socket,
      match: match,
      scores: scores,
      feed_items: feed_items,
      selected_score: nil,
      selected_penalty: nil
    )

    {:ok, socket}
  end

  # INFO HANDLER
  def handle_info({:feed_item_added, %{:id => id, :score => score, :penalty => penalty, created_at: created_at}}, socket) do
    if (score.match_id != socket.assigns.match.id), do: {:noreply, socket}

    message = generate_message(penalty, score)

    socket = update(socket, :feed_items, fn feed_items ->
      [ %{id: id, message: message, penalty: penalty, score_id: score.id, created_at: created_at} | feed_items ]
    end)

    {:noreply, socket}
  end

  def handle_info({:feed_item_removed, id}, socket) do
    socket = update(socket, :feed_items, fn feed_items ->
      Enum.filter(feed_items, fn m -> m[:id] != id end)
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
  def handle_event("decrement", %{"item-id" => item_id, "penalty" => penalty, "score-id" => score_id}, socket) do
    score = Game.get_score!(score_id)
    Game.decrease_penalty(score, String.to_atom(penalty))

    Game.ControlPanelServer.remove_item(score.match_id, item_id)

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

  defp generate_message(penalty, score) do
    score = Repo.preload(score, :player)

    "#{penalty_string(penalty)} Strafe für #{score.player.name}"
  end

  defp penalty_string(penalty) do
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
