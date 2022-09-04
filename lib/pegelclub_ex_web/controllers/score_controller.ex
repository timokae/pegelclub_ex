defmodule PegelclubExWeb.ScoreController do
  use PegelclubExWeb, :controller

  alias PegelclubEx.{Game, Repo}
  alias PegelclubEx.Game.{Score, Match}

  def index(conn, _params) do
    scores = Game.list_scores()
    render(conn, "index.html", scores: scores)
  end

  def new(conn, %{"match_id" => match_id}) do
    match = Game.get_match!(match_id)
    addable_guests = Game.list_addable_guests(match)
    changeset = Score.create_changeset(%Score{}, %{match_id: match.id})

    render(conn, "new.html", changeset: changeset, match: match, guests: addable_guests)
  end

  def create(conn, %{"score" => score_params}) do
    case Game.create_score(score_params) do
      {:ok, score} ->
        conn
        |> put_flash(:info, "Score created successfully.")
        |> redirect(to: Routes.match_path(conn, :show, score.match_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    score = Game.get_score!(id)
    render(conn, "show.html", score: score)
  end

  def edit(conn, %{"id" => id, "match_id" => _match_id}) do
    score = Game.get_score!(id) |> Repo.preload(:player)

    changeset = Game.change_score_penalties(score)
    render(conn, "edit.html", score: score, changeset: changeset)
  end

  def update(conn, %{"id" => id, "score" => score_params}) do
    score = Game.get_score!(id)

    case Game.update_score_penalties(score, score_params) do
      {:ok, score} ->
        conn
        |> put_flash(:info, "Score updated successfully.")
        |> redirect(to: Routes.match_path(conn, :show, score.match_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", score: score, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    score = Game.get_score!(id)
    {:ok, _score} = Game.delete_score(score)

    conn
    |> put_flash(:info, "Player successfully removed from match!")
    |> redirect(to: Routes.match_path(conn, :show, score.match_id))
  end
end
