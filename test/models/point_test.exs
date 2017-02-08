defmodule Draw.PointTest do
  use Draw.ModelCase

  alias Draw.Point

  @valid_attrs %{drawing_id: 1, color: "000000", x: 42, y: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Point.changeset(%Point{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Point.changeset(%Point{}, @invalid_attrs)
    refute changeset.valid?
  end
end
