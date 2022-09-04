defmodule PegelclubEx.GameTest do
  use PegelclubEx.DataCase

  alias PegelclubEx.Game

  describe "scores" do
    alias PegelclubEx.Game.Score

    import PegelclubEx.GameFixtures

    @invalid_attrs %{delay: nil, early_leave: nil, is_present: nil, other: nil, penalty_100: nil, penalty_125: nil, penalty_150: nil, penalty_175: nil, penalty_25: nil, penalty_50: nil, penalty_500: nil, penalty_75: nil, penalty_pudel: nil}

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Game.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Game.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      valid_attrs = %{delay: 42, early_leave: 42, is_present: true, other: 42, penalty_100: 42, penalty_125: 42, penalty_150: 42, penalty_175: 42, penalty_25: 42, penalty_50: 42, penalty_500: 42, penalty_75: 42, penalty_pudel: 42}

      assert {:ok, %Score{} = score} = Game.create_score(valid_attrs)
      assert score.delay == 42
      assert score.early_leave == 42
      assert score.is_present == true
      assert score.other == 42
      assert score.penalty_100 == 42
      assert score.penalty_125 == 42
      assert score.penalty_150 == 42
      assert score.penalty_175 == 42
      assert score.penalty_25 == 42
      assert score.penalty_50 == 42
      assert score.penalty_500 == 42
      assert score.penalty_75 == 42
      assert score.penalty_pudel == 42
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      update_attrs = %{delay: 43, early_leave: 43, is_present: false, other: 43, penalty_100: 43, penalty_125: 43, penalty_150: 43, penalty_175: 43, penalty_25: 43, penalty_50: 43, penalty_500: 43, penalty_75: 43, penalty_pudel: 43}

      assert {:ok, %Score{} = score} = Game.update_score(score, update_attrs)
      assert score.delay == 43
      assert score.early_leave == 43
      assert score.is_present == false
      assert score.other == 43
      assert score.penalty_100 == 43
      assert score.penalty_125 == 43
      assert score.penalty_150 == 43
      assert score.penalty_175 == 43
      assert score.penalty_25 == 43
      assert score.penalty_50 == 43
      assert score.penalty_500 == 43
      assert score.penalty_75 == 43
      assert score.penalty_pudel == 43
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_score(score, @invalid_attrs)
      assert score == Game.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Game.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Game.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Game.change_score(score)
    end
  end
end
