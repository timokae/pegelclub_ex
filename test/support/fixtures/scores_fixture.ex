defmodule PegelclubEx.ScoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PegelclubEx.Game` context.
  """

  @doc """
  Generate a score.
  """
  def score_fixture(attrs \\ %{}) do
    {:ok, score} =
      attrs
      |> Enum.into(%{
        delay: 42,
        early_leave: 42,
        is_present: true,
        other: 42,
        penalty_100: 42,
        penalty_125: 42,
        penalty_150: 42,
        penalty_175: 42,
        penalty_25: 42,
        penalty_50: 42,
        penalty_500: 42,
        penalty_75: 42,
        penalty_pudel: 42
      })
      |> PegelclubEx.Game.create_score()

    score
  end

  @spec empty_score_fixture(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def empty_score_fixture(attrs) do
    {:ok, player} = PegelclubEx.Game.create_player(%{name: "Fixture User", guest: false})
    {:ok, match} = PegelclubEx.Game.create_match(%{played_at: Date.new!(2020, 10, 1)})
    {:ok, score} = PegelclubEx.Game.create_score(%{player_id: player.id, match_id: match.id})

    {:ok, score} = PegelclubEx.Game.update_score(score, attrs)

    score
  end

  def guest_score_fixture(attrs) do
    {:ok, player} = PegelclubEx.Game.create_player(%{name: "Fixture Guest", guest: true})
    {:ok, match} = PegelclubEx.Game.create_match(%{played_at: Date.new!(2020, 10, 2)})
    {:ok, score} = PegelclubEx.Game.create_score(%{player_id: player.id, match_id: match.id})

    {:ok, score} = PegelclubEx.Game.update_score(score, attrs)
    score
  end
end
