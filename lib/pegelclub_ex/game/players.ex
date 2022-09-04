defmodule PegelclubEx.Game.Players do
  import Ecto.Query, warn: false

  alias PegelclubEx.Repo
  alias PegelclubEx.Game.Player

  @guest_starting_fee 500
  @starting_fee 1000

  def starting_fee(%Player{guest: true}), do: @guest_starting_fee
  def starting_fee(%Player{guest: false}), do: @starting_fee

  def get!(id) do
    Repo.get!(Player, id)
  end

  def delete(%Player{} = player) do
    Repo.delete(player)
  end

  def list do
    Repo.all(Player)
  end

  def list_regulars() do
    query = from p in Player,
      where: p.guest == false,
      select: p

    Repo.all(query)
  end

  def list_guests() do
    query = from p in Player,
      where: p.guest == true,
      select: p

    Repo.all(query)
  end

  def create(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end
end
