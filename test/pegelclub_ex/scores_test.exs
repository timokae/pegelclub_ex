defmodule PegelclubEx.ScoresTest do
  use PegelclubEx.DataCase

  import PegelclubEx.ScoresFixtures

  alias PegelclubEx.Game.Scores

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

  @guest_starting_fee 500
  @starting_fee 1000

  describe "scores" do

    # DELAY

    test "penalty_delay returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_delay(score) == 0
    end

    test "penalty_delay returns correct currency value" do
      score = empty_score_fixture(%{delay: 5})
      assert Scores.penalty_delay(score) == 5 * @penalty_delay
    end

    test "penalty_delay is limited to 10 euros" do
      score = empty_score_fixture(%{delay: 99999})
      assert Scores.penalty_delay(score) == @delay_limit
    end

    # EARLY LEAVE

    test "penalty_early_leave returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_delay(score) == 0
    end

    test "penalty_early_leave returns correct currency value" do
      score = empty_score_fixture(%{early_leave: 5})
      assert Scores.penalty_early_leave(score) == 5 * @penalty_early_leave
    end

    test "penalty_early_leave is limited to 10 euros" do
      score = empty_score_fixture(%{early_leave: 99999})
      assert Scores.penalty_early_leave(score) == @early_leave_limit
    end

    # PENALTY 25

    test "penalty_25 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_25(score) == 0
    end

    test "penalty_25 returns correct currency value" do
      score = empty_score_fixture(%{penalty_25: 10})
      assert Scores.penalty_25(score) == 10 * @penalty_25
    end

    # PENALTY 50

    test "penalty_50 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_50(score) == 0
    end

    test "penalty_50 returns correct currency value" do
      score = empty_score_fixture(%{penalty_50: 10})
      assert Scores.penalty_50(score) == 10 * @penalty_50
    end

    # PENALTY 75

    test "penalty_75 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_75(score) == 0
    end

    test "penalty_75 returns correct currency value" do
      score = empty_score_fixture(%{penalty_75: 10})
      assert Scores.penalty_75(score) == 10 * @penalty_75
    end

    # PENALTY 100

    test "penalty_100 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_100(score) == 0
    end

    test "penalty_100 returns correct currency value" do
      score = empty_score_fixture(%{penalty_100: 10})
      assert Scores.penalty_100(score) == 10 * @penalty_100
    end

    # PENALTY 125

    test "penalty_125 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_125(score) == 0
    end

    test "penalty_125 returns correct currency value" do
      score = empty_score_fixture(%{penalty_125: 10})
      assert Scores.penalty_125(score) == 10 * @penalty_125
    end

    # PENALTY 150

    test "penalty_150 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_150(score) == 0
    end

    test "penalty_150 returns correct currency value" do
      score = empty_score_fixture(%{penalty_150: 10})
      assert Scores.penalty_150(score) == 10 * @penalty_150
    end

    # PENALTY 175

    test "penalty_175 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_175(score) == 0
    end

    test "penalty_175 returns correct currency value" do
      score = empty_score_fixture(%{penalty_175: 10})
      assert Scores.penalty_175(score) == 10 * @penalty_175
    end

    # PENALTY 500

    test "penalty_500 returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_500(score) == 0
    end

    test "penalty_500 returns correct currency value" do
      score = empty_score_fixture(%{penalty_500: 10})
      assert Scores.penalty_500(score) == 10 * @penalty_500
    end

    # PENALTY_PUDEL

    test "penalty_pudel returns 0 when is 0 (is not pudel king)" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_pudel(score, 1) == 0
    end

    test "penalty_pudel returns correct currency value (is not pudel king)" do
      score = empty_score_fixture(%{penalty_pudel: 10})
      assert Scores.penalty_pudel(score, 11) == 10 * @penalty_pudel
    end

    test "penalty_pudel returns closest step (500) (is pudel king)" do
      score = empty_score_fixture(%{penalty_pudel: 19})
      assert Scores.penalty_pudel(score, 19) == 500
    end

    test "penalty_pudel returns closest step (1000) (is pudel king)" do
      score = empty_score_fixture(%{penalty_pudel: 21})
      assert Scores.penalty_pudel(score, 21) == 1000
    end

    # PENALTY OTHER

    test "penalty_other returns 0 when is 0" do
      score = empty_score_fixture(%{})
      assert Scores.penalty_other(score) == 0
    end

    test "penalty_other returns correct currency value" do
      score = empty_score_fixture(%{other: 10})
      assert Scores.penalty_other(score) == 10 * 100
    end

    # PENALTY SUM

    test "sums all penalties (delay and early_leave below limit)" do
      score = empty_score_fixture(%{
        delay: 1,
        early_leave: 1,
        other: 1,
        penalty_25: 1,
        penalty_50: 1,
        penalty_75: 1,
        penalty_100: 1,
        penalty_125: 1,
        penalty_150: 1,
        penalty_175: 1,
        penalty_500: 1,
        penalty_pudel: 1
      })

      assert Scores.penalty_sum(score) == 1500
      assert Scores.penalty_sum(score, 2) == 1525
    end

    test "sums all penalties (delay and early_leave above limit)" do
      score = empty_score_fixture(%{
        delay: 11,
        early_leave: 11,
        other: 1,
        penalty_25: 1,
        penalty_50: 1,
        penalty_75: 1,
        penalty_100: 1,
        penalty_125: 1,
        penalty_150: 1,
        penalty_175: 1,
        penalty_500: 1,
        penalty_pudel: 1
      })

      assert Scores.penalty_sum(score) == 3300
      assert Scores.penalty_sum(score, 2) == 3325
    end

    test "sums all penalties and rounds pudel to 5" do
      score = empty_score_fixture(%{
        delay: 1,
        early_leave: 1,
        other: 1,
        penalty_25: 1,
        penalty_50: 1,
        penalty_75: 1,
        penalty_100: 1,
        penalty_125: 1,
        penalty_150: 1,
        penalty_175: 1,
        penalty_500: 1,
        penalty_pudel: 1
      })

      assert Scores.penalty_sum(score, 1) == 2000
    end

    test "sums all penalties and rounds pudel to 10" do
      score = empty_score_fixture(%{
        delay: 1,
        early_leave: 1,
        other: 1,
        penalty_25: 1,
        penalty_50: 1,
        penalty_75: 1,
        penalty_100: 1,
        penalty_125: 1,
        penalty_150: 1,
        penalty_175: 1,
        penalty_500: 1,
        penalty_pudel: 21
      })

      assert Scores.penalty_sum(score, 21) == 2500
    end

    # TOTAL

    test "includes starting fee in total (regular)" do
      attrs = %{
        delay: 1,
        early_leave: 1,
        other: 1,
        penalty_100: 1,
        penalty_125: 1,
        penalty_150: 1,
        penalty_175: 1,
        penalty_25: 1,
        penalty_50: 1,
        penalty_500: 1,
        penalty_75: 1,
        penalty_pudel: 1
      }
      regular_score = empty_score_fixture(attrs)
      guest_score = guest_score_fixture(attrs)
      result = 1500

      assert Scores.total(regular_score, 2) == 1525 + @starting_fee
      assert Scores.total(guest_score, 2) == 1525 + @guest_starting_fee
    end
  end
end
