defmodule PegelclubEx.Game.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias PegelclubEx.Game.{Score, Player}

  schema "players" do
    field :guest, :boolean, default: false
    field :name, :string
    field :active, :boolean, default: true

    has_many :scores, Score

    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:name, :guest, :active])
    |> validate_required([:name, :guest, :active])
    |> unique_constraint([:name], message: "Es existiert bereits ein Spieler mit diesem Namen")
  end
end
