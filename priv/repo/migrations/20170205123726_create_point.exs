defmodule Draw.Repo.Migrations.CreatePoint do
  use Ecto.Migration

  def change do
    create table(:points, primary_key: false) do
      add :drawing_id, references(:drawings, type: :binary_id), primary_key: true
      add :x, :integer, primary_key: true
      add :y, :integer, primary_key: true
      add :color, :string

      timestamps()
    end

  end

  def down do
    drop table(:points)
  end
end
