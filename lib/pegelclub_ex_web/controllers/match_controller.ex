defmodule PegelclubExWeb.MatchController do
  use PegelclubExWeb, :controller

  alias PegelclubEx.{Game, Repo}
  alias PegelclubEx.Game.{Match}

  def index(conn, _params) do
    matches = Game.list_matches()
    stats = Game.all_match_stats

    render(conn, "index.html", matches: matches, stats: stats)
  end

  def new(conn, _params) do
    changeset = Game.change_match(%Match{}, %{played_at: Date.utc_today})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"match" => match_params}) do
    case Game.create_match_with_scores(match_params) do
      {:ok, match} ->
        conn
        |> put_flash(:info, "Match created successfully.")
        |> redirect(to: Routes.live_path(conn, PegelclubExWeb.MatchLive, match.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    match = Game.get_match!(id)
      |> Repo.preload(scores: :player)

    render(conn, "show.html",
      match: match,
      scores: Game.match_scores_sorted_by_name(match),
      match_stats: Game.match_stats(match)
    )
  end

  def delete(conn, %{"id" => id}) do
    match = Game.get_match!(id)
    {:ok, _match} = Game.delete_match(match)

    conn
    |> put_flash(:info, "Spielstand erfolgreich gelöscht!")
    |> redirect(to: Routes.match_path(conn, :index))
  end
end
