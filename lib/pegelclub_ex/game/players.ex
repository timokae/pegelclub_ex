defmodule PegelclubEx.Game.Players do
  import Ecto.Query, warn: false

  alias PegelclubEx.Repo
  alias PegelclubEx.Game.{Player, PlayerQuery}

  @guest_starting_fee 500
  @starting_fee 1000

  def starting_fee(%Player{guest: true}), do: @guest_starting_fee
  def starting_fee(%Player{guest: false}), do: @starting_fee

  def get!(id) do
    Repo.get!(Player, id)
  end

  def update(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Player{} = player) do
    Repo.delete(player)
  end

  def list do
    Repo.all(PlayerQuery.all)
  end

  def list_regulars() do
    Player
    |> PlayerQuery.regulars()
    |> Repo.all()
  end

  def list_active_regulars() do
    Player
    |> PlayerQuery.regulars()
    |> PlayerQuery.active()
    |> Repo.all()
  end

  def list_guests() do
    Player
    |> PlayerQuery.guests()
    |> Repo.all()
  end

  def list_active_guests() do
    Player
    |> PlayerQuery.guests()
    |> PlayerQuery.active()
    |> Repo.all()
  end

  def create(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end
end
