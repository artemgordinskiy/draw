defmodule Draw.Repo.Migrations.CreatePoint do
  use Ecto.Migration

  def change do
    create table(:points, primary_key: false) do
      add :drawing_id, references(:drawings, type: :uuid)
      add :x, :integer
      add :y, :integer
      add :color, :string

      timestamps()
    end

  end

  def down do
    drop table(:points)
  end
end
