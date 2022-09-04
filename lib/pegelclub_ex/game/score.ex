defmodule PegelclubEx.Game.Score do
  use Ecto.Schema
  import Ecto.Changeset

  alias PegelclubEx.Game.{Match, Player}

  schema "scores" do
    field :delay,         :integer, default: 0
    field :early_leave,   :integer, default: 0
    field :other,         :integer, default: 0
    field :penalty_100,   :integer, default: 0
    field :penalty_125,   :integer, default: 0
    field :penalty_150,   :integer, default: 0
    field :penalty_175,   :integer, default: 0
    field :penalty_25,    :integer, default: 0
    field :penalty_50,    :integer, default: 0
    field :penalty_500,   :integer, default: 0
    field :penalty_75,    :integer, default: 0
    field :penalty_pudel, :integer, default: 0

    field :is_present, :boolean, default: true

    belongs_to :match, Match
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:player_id, :match_id, :penalty_pudel, :penalty_25, :penalty_50, :penalty_75, :penalty_100, :penalty_125, :penalty_150, :penalty_175, :penalty_500, :delay, :early_leave, :other, :is_present])
  end

  def create_changeset(score, attrs) do
    score
    |> cast(attrs, [:player_id, :match_id])
    |> validate_required([:player_id, :match_id])
    |> unique_constraint([:player_id, :match_id])
  end

  def penalty_changeset(score, attrs) do
    score
    |> cast(attrs, [:penalty_pudel, :penalty_25, :penalty_50, :penalty_75, :penalty_100, :penalty_125, :penalty_150, :penalty_175, :penalty_500, :early_leave, :delay, :other, :is_present])
    |> validate_number(:penalty_pudel, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_25, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_50, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_75, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_100, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_125, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_150, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_175, greater_than_or_equal_to: 0)
    |> validate_number(:penalty_500, greater_than_or_equal_to: 0)
    |> validate_number(:delay, greater_than_or_equal_to: 0)
    |> validate_number(:early_leave, greater_than_or_equal_to: 0)
    |> validate_number(:other, greater_than_or_equal_to: 0)
  end
end
