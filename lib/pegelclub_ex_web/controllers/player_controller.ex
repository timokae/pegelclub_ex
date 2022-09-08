defmodule PegelclubExWeb.PlayerController do
  use PegelclubExWeb, :controller

  alias PegelclubEx.Game
  alias PegelclubEx.Game.Player

  def index(conn, _params) do
    players = Game.list_players()
    render(conn, "index.html", players: players)
  end

  def new(conn, _params) do
    changeset = Game.change_player(%Player{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"player" => player_params}) do
    case Game.create_player(player_params) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: Routes.player_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    changeset =
      Game.get_player!(id)
      |> Game.change_player(%{})

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Game.get_player!(id)

    case Game.update_player(player, player_params) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Spieler erfolgreich geupdated")
        |> redirect(to: Routes.player_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
