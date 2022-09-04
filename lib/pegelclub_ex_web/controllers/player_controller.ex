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

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
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
end
