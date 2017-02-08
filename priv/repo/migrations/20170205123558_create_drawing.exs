defmodule Draw.Repo.Migrations.CreateDrawing do
  use Ecto.Migration

  def change do
    create table(:drawings, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

  end

  def down do
    drop table(:drawings)
  end
end
