defmodule PegelclubEx.Repo.Migrations.AddActiveToPlayer do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :active, :boolean, default: true, null: false
    end
  end
end
