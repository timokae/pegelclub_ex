defmodule PegelclubEx.Game.ControlPanelServer do
  use GenServer

  alias PegelclubEx.Game

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    Game.Scores.subscribe()

    {:ok, opts}
  end

  # Public Interface

  def push_item(item) do
    GenServer.cast(__MODULE__, {:push_item, item})
  end

  def remove_item(match_id, item_id) do
    GenServer.cast(__MODULE__, {:remove_item, match_id, item_id})
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def get_feed(match_id) do
    GenServer.call(__MODULE__, {:get_feed, match_id})
  end

  # PubSub Handlers

  def handle_info({:feed_item_added, item}, state) do
    push_item(item)

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  # Internal Interface

  def handle_cast({:push_item, %{penalty: penalty, score: score}}, state) do
    new_value = %{id: Ecto.UUID.generate, penalty: penalty, score: score, created_at: Timex.now("Europe/Berlin")}
    new_state = Map.update(
      state,
      score.match_id,
      [new_value],
      fn match_feed -> [new_value | match_feed] end
    )

    broadcast_item_added(new_value)

    {:noreply, new_state}
  end

  def handle_cast({:remove_item, match_id, item_id}, state) do
    new_state = Map.update(state, match_id, [], fn items ->
      Enum.filter(items, fn item -> item[:id] != item_id end)
    end)

    broadcast_item_removed(match_id, item_id)

    {:noreply, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_feed, match_id}, _from, state) do
    {:reply, Map.get(state, match_id, []), state}
  end

  defp broadcast_item_added(%{score: score} = item) do
    Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "match_scores_#{score.match_id}", {:feed_item_added, item})
  end

  defp broadcast_item_removed(match_id, item_id) do
    Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "match_scores_#{match_id}", {:feed_item_removed, item_id})
  end
end
