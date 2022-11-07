defmodule PegelclubEx.Repo.Migrations.AddHasPayedToScore do
  use Ecto.Migration

  def change do
    alter table("scores") do
      add :has_payed, :boolean, default: false, null: false
    end
  end
end
