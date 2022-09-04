defmodule PegelclubEx.Repo.Migrations.CreateGameEntities do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :guest, :boolean, default: false, null: false

      timestamps()
    end

    create table(:matches) do
      add :played_at, :date

      timestamps()
    end

    create table(:scores) do
      add :penalty_pudel, :integer, default: 0, null: false
      add :penalty_25,    :integer, default: 0, null: false
      add :penalty_50,    :integer, default: 0, null: false
      add :penalty_75,    :integer, default: 0, null: false
      add :penalty_100,   :integer, default: 0, null: false
      add :penalty_125,   :integer, default: 0, null: false
      add :penalty_150,   :integer, default: 0, null: false
      add :penalty_175,   :integer, default: 0, null: false
      add :penalty_500,   :integer, default: 0, null: false
      add :delay,         :integer, default: 0, null: false
      add :early_leave,   :integer, default: 0, null: false
      add :other,         :integer, default: 0, null: false

      add :is_present, :boolean, default: false, null: false

      add :player_id, references(:players)
      add :match_id, references(:matches)

      timestamps()
    end
  end
end
