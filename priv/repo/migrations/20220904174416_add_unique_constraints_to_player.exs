defmodule PegelclubEx.Repo.Migrations.AddUniqueConstraintsToPlayer do
  use Ecto.Migration

  def change do
    create unique_index(:players, [:name])
    create unique_index(:matches, [:played_at])
    create unique_index(:scores, [:player_id, :match_id])
  end
end
