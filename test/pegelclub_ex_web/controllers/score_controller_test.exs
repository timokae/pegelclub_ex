defmodule PegelclubExWeb.ScoreControllerTest do
  use PegelclubExWeb.ConnCase

  import PegelclubEx.GameFixtures

  @create_attrs %{delay: 42, early_leave: 42, is_present: true, other: 42, penalty_100: 42, penalty_125: 42, penalty_150: 42, penalty_175: 42, penalty_25: 42, penalty_50: 42, penalty_500: 42, penalty_75: 42, penalty_pudel: 42}
  @update_attrs %{delay: 43, early_leave: 43, is_present: false, other: 43, penalty_100: 43, penalty_125: 43, penalty_150: 43, penalty_175: 43, penalty_25: 43, penalty_50: 43, penalty_500: 43, penalty_75: 43, penalty_pudel: 43}
  @invalid_attrs %{delay: nil, early_leave: nil, is_present: nil, other: nil, penalty_100: nil, penalty_125: nil, penalty_150: nil, penalty_175: nil, penalty_25: nil, penalty_50: nil, penalty_500: nil, penalty_75: nil, penalty_pudel: nil}

  describe "index" do
    test "lists all scores", %{conn: conn} do
      conn = get(conn, Routes.score_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Scores"
    end
  end

  describe "new score" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.score_path(conn, :new))
      assert html_response(conn, 200) =~ "New Score"
    end
  end

  describe "create score" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.score_path(conn, :create), score: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.score_path(conn, :show, id)

      conn = get(conn, Routes.score_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Score"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.score_path(conn, :create), score: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Score"
    end
  end

  describe "edit score" do
    setup [:create_score]

    test "renders form for editing chosen score", %{conn: conn, score: score} do
      conn = get(conn, Routes.score_path(conn, :edit, score))
      assert html_response(conn, 200) =~ "Edit Score"
    end
  end

  describe "update score" do
    setup [:create_score]

    test "redirects when data is valid", %{conn: conn, score: score} do
      conn = put(conn, Routes.score_path(conn, :update, score), score: @update_attrs)
      assert redirected_to(conn) == Routes.score_path(conn, :show, score)

      conn = get(conn, Routes.score_path(conn, :show, score))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, score: score} do
      conn = put(conn, Routes.score_path(conn, :update, score), score: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Score"
    end
  end

  describe "delete score" do
    setup [:create_score]

    test "deletes chosen score", %{conn: conn, score: score} do
      conn = delete(conn, Routes.score_path(conn, :delete, score))
      assert redirected_to(conn) == Routes.score_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.score_path(conn, :show, score))
      end
    end
  end

  defp create_score(_) do
    score = score_fixture()
    %{score: score}
  end
end
