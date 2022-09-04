defmodule PegelclubEx.GameFixtures do
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
end
