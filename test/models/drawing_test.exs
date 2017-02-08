defmodule Draw.DrawingTest do
  use Draw.ModelCase

  alias Draw.Drawing

  @valid_attrs %{name: "some content", uuid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Drawing.changeset(%Drawing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Drawing.changeset(%Drawing{}, @invalid_attrs)
    refute changeset.valid?
  end
end
