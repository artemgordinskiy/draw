defmodule Draw.PointTest do
  use Draw.ModelCase

  alias Draw.{Repo, Point, Drawing}

  @valid_attrs %{drawing_id: "bb7413bc-fb90", color: "000000", x: 42, y: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Point.changeset(%Point{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Point.changeset(%Point{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "inserting a point into the database" do
    drawing = Drawing.changeset(%Drawing{}, %{name: "Mona Lisa"})
    |> Repo.insert!

    Point.changeset(%Point{}, %{drawing_id: drawing.id, color: "000000", x: 42, y: 42})
    |> Repo.insert!
  end
end
