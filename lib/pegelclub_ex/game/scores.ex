defmodule PegelclubEx.Game.Scores do

  alias PegelclubEx.Repo
  alias PegelclubEx.Game.{Players, Score}

  @delay_limit 1_000
  @early_leave_limit 1_000

  @penalty_delay 100
  @penalty_early_leave 100

  @penalty_pudel 25
  @penalty_25  25
  @penalty_50  50
  @penalty_75  75
  @penalty_100 100
  @penalty_125 125
  @penalty_150 150
  @penalty_175 175
  @penalty_500 500

  def list do
    Repo.all(Score)
  end

  def get!(id) do
    Repo.get!(Score, id)
  end

  def create(attrs) do
    %Score{}
    |> Score.create_changeset(attrs)
    |> Repo.insert()
  end

  def update(%Score{} = score, attrs) do
    score
    |> Score.changeset(attrs)
    |> Repo.update()
  end

  def update_penalties(%Score{} = score, attrs) do
    score
    |> Score.penalty_changeset(attrs)
    |> Repo.update()
    |> broadcast(:score_updated)
  end

  def increase_penalty(%Score{} = score, penalty) do
    old_value = Map.get(score, penalty)

    result =
      Score.penalty_changeset(score, Map.put(%{}, penalty, old_value + 1))
      |> Repo.update()

    case result do
      {:ok, score} ->
        broadcast(result, :score_updated)
        broadcast_feed_item_added({:ok, %{score: score, penalty: penalty}})
      {:error, _reason} ->
        broadcast_feed_item_added(result)
    end
  end

  def decrease_penalty(%Score{} = score, penalty) do
    old_value = Map.get(score, penalty)

    Score.penalty_changeset(score, Map.put(%{}, penalty, old_value - 1))
    |> Repo.update()
    |> broadcast(:score_updated)
  end

  def delete(%Score{} = score) do
    Repo.delete(score)
  end

  def penalty_sum(score) do
    [
      penalty_25(score),
      penalty_50(score),
      penalty_75(score),
      penalty_100(score),
      penalty_125(score),
      penalty_150(score),
      penalty_175(score),
      penalty_500(score),
      penalty_delay(score),
      penalty_early_leave(score),
      penalty_other(score)
    ] |> Enum.sum()
  end

  def penalty_sum(score, pudel_king_value) do
    penalty_sum(score) + penalty_pudel(score, pudel_king_value)
  end

  def penalty_delay(%Score{} = score) do
    Enum.min([score.delay * @penalty_delay, @delay_limit])
  end

  def penalty_early_leave(%Score{} = score) do
    Enum.min([score.early_leave * @penalty_early_leave, @early_leave_limit])
  end

  def penalty_25(%Score{} = score), do: score.penalty_25 * @penalty_25
  def penalty_50(%Score{} = score), do: score.penalty_50 * @penalty_50
  def penalty_75(%Score{} = score), do: score.penalty_75 * @penalty_75
  def penalty_100(%Score{} = score), do: score.penalty_100 * @penalty_100
  def penalty_125(%Score{} = score), do: score.penalty_125 * @penalty_125
  def penalty_150(%Score{} = score), do: score.penalty_150 * @penalty_150
  def penalty_175(%Score{} = score), do: score.penalty_175 * @penalty_175
  def penalty_500(%Score{} = score), do: score.penalty_500 * @penalty_500
  def penalty_other(%Score{} = score), do: score.other * 100

  def penalty_pudel(%Score{} = score, pudel_king_value) do
    result = score.penalty_pudel * @penalty_pudel;

    if score.penalty_pudel == pudel_king_value do
      Float.ceil(result / 500) * 500
    else
      result
    end
  end

  def total(score, pudel_king_value) do
    score = score |> Repo.preload(:player)

    penalty_sum(score, pudel_king_value) + Players.starting_fee(score.player)
  end

  def subscribe(match_id) do
    Phoenix.PubSub.subscribe(PegelclubEx.PubSub, "match_scores_#{match_id}")
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(PegelclubEx.PubSub, "match_scores")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "match_scores_#{score.match_id}", {event, score})
    {:ok, score}
  end

  defp broadcast_feed_item_added({:error, _reason} = error), do: error
  defp broadcast_feed_item_added({:ok, item}) do
    Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "match_scores", {:feed_item_added, item})
    {:ok, item}
  end

  # defp broadcast_decrease({:error, _reason} = error, _event), do: error
  # defp broadcast_decrease({:ok, decrease_map}, event) do
  #   Phoenix.PubSub.broadcast(PegelclubEx.PubSub, "scores", {event, decrease_map})
  #   {:ok, decrease_map}
  # end
end
