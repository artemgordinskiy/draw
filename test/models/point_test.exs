defmodule Draw.PointTest do
  use Draw.ModelCase

  alias Draw.{Repo, Point, Drawing}

  @valid_attrs %{drawing_id: "uuid", color: "000000", x: 42, y: 42}
  @invalid_attrs %{}

  defp real_point_attrs() do
    drawing = %Drawing{}
    |> Drawing.changeset(%{name: "Mona Lisa"})
    |> Repo.insert!

    Map.put(@valid_attrs, :drawing_id, drawing.id)
  end

  test "changeset with valid attributes" do
    changeset = Point.changeset(%Point{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Point.changeset(%Point{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "inserting a point into the database" do
    Point.changeset(%Point{}, real_point_attrs())
    |> Repo.insert!
  end

  test "retrieving points from the database" do
    point_attrs = real_point_attrs()

    %Point{}
    |> Point.changeset(point_attrs)
    |> Repo.insert!

    %Point{}
    |> Point.changeset(Map.put(point_attrs, :y, point_attrs.y + 1))
    |> Repo.insert!

    assert 2 = Repo.all(from p in Point, where: p.drawing_id == ^point_attrs.drawing_id)
    |> Enum.count
  end

  test "upserting a point in the database" do
    point_attrs = real_point_attrs()

    %Point{}
    |> Point.changeset(point_attrs)
    |> Repo.insert!

    updated_point = %Point{}
    |> Point.changeset(Map.put(point_attrs, :color, "FFFFFF"))
    |> Repo.insert!(on_conflict: [set: [color: point_attrs.color]],
                    conflict_target: [:drawing_id, :x, :y])

    assert updated_point.color == "FFFFFF"
  end

  test "removing a point from the database" do
    point = %Point{}
    |> Point.changeset(real_point_attrs())
    |> Repo.insert!

    assert {:ok, _} = Repo.delete(point)
  end
end
