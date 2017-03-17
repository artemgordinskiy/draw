defmodule Draw.DrawingTest do
  use Draw.ModelCase

  alias Draw.{Repo, Drawing}

  import Ecto.Query, only: [from: 2]

  @valid_attrs %{name: "Mona Lisa"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Drawing.changeset(%Drawing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Drawing.changeset(%Drawing{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "inserting a drawing into the database" do
    Drawing.changeset(%Drawing{}, @valid_attrs)
    |> Repo.insert!
  end

  test "retrieving a drawing from the database" do
    drawing = Drawing.changeset(%Drawing{}, @valid_attrs)
    |> Repo.insert!

    refute Repo.all(from d in Drawing, where: d.id == ^drawing.id)
    |> Enum.empty?
  end
end
