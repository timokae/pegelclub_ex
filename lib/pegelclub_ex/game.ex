defmodule PegelclubEx.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false

  alias PegelclubEx.Game.{Score, Scores, Match, Matches, Player, Players}

  # SCORES
  def list_scores, do: Scores.list

  def get_score!(id), do: Scores.get!(id)

  def create_score(attrs \\ %{}), do: Scores.create(attrs)

  def update_score(%Score{} = score, attrs), do: Scores.update(score, attrs)

  def update_score_penalties(%Score{} = score, attrs), do: Scores.update_penalties(score, attrs)

  def increase_penalty(%Score{} = score, penalty), do: Scores.increase_penalty(score, penalty)

  def decrease_penalty(%Score{} = score, penalty), do: Scores.decrease_penalty(score, penalty)

  def delete_score(%Score{} = score), do: Scores.delete(score)

  def change_score(%Score{} = score, attrs \\ %{}) do
    Score.changeset(score, attrs)
  end

  def change_score_penalties(%Score{} = score, attrs \\ %{}) do
    Score.penalty_changeset(score, attrs)
  end

  def subscribe_to_scores(match_id), do: Scores.subscribe(match_id)
  def subscribe_to_scores(), do: Scores.subscribe()

  def penalty_sum(%Score{} = score), do: Scores.penalty_sum(score)
  def penalty_sum(%Score{} = score, pudel_king_value), do: Scores.penalty_sum(score, pudel_king_value)

  # MATCHES

  def list_matches(), do: Matches.list()

  def get_match!(id), do: Matches.get!(id)

  def create_match_with_scores(attrs), do: Matches.create_with_scores(attrs)

  def create_match(attrs), do: Matches.create(attrs)

  def delete_match(%Match{} = match), do: Matches.delete(match)

  def change_match(%Match{} = match, attrs), do: Match.changeset(match, attrs)

  def match_stats(%Match{} = match), do: Matches.stats(match)

  def all_match_stats(), do: Matches.all_stats()

  def match_scores_sorted_by_name(%Match{} = match), do: Matches.sorted_scores(match)

  def list_addable_guests(%Match{} = match), do: Matches.list_addable_guests(match)

  # PLAYERS

  def get_player!(id), do: Players.get!(id)

  def update_player(%Player{} = player, attrs), do: Players.update(player, attrs)

  def delete_player(%Player{} = player), do: Players.delete(player)
  def list_players, do: Players.list()

  def list_regulars, do: Players.list_regulars()

  def list_regular_players(), do: Players.list_regulars()

  def create_player(attrs), do: Players.create(attrs)

  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end
end
