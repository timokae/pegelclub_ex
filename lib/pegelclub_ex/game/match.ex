defmodule PegelclubEx.Game.Match do
  use Ecto.Schema

  import Ecto.Changeset

  alias PegelclubEx.Game.Score

  schema "matches" do
    field :played_at, :date

    has_many :scores, Score, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:played_at])
    |> validate_required([:played_at])
    |> unique_constraint([:played_at], message: "Für dieses Datum existiert bereits ein Spiel")
  end
end
