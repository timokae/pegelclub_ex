defmodule PegelclubExWeb.PlayerController do
  use PegelclubExWeb, :controller

  alias PegelclubEx.Game
  alias PegelclubEx.Game.Player

  def index(conn, _params) do
    players = Game.list_players()
    render(conn, "index.html", players: players)
  end

  def new(conn, %{"redirect" => redirect_url}) do
    changeset = Game.change_player(%Player{}, %{})
    render(conn, "new.html", changeset: changeset, redirect_url: redirect_url)
  end

  def new(conn, _params) do
    redirect_url = PegelclubExWeb.Router.Helpers.player_path(conn, :index)
    changeset = Game.change_player(%Player{}, %{})
    render(conn, "new.html", changeset: changeset, redirect_url: redirect_url)
  end

  def create(conn, %{"player" => player_params} = params) do
    redirect_to =
      if params["redirect"] do
        URI.decode_www_form(params["redirect"])
      else
        Routes.player_path(conn, :index)
      end

    case Game.create_player(player_params) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: redirect_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, redirect: URI.encode_www_form(redirect_to))
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
