defmodule Draw.Point do
  use Draw.Web, :model

  @primary_key false

  schema "points" do
    field :x, :integer, primary_key: true
    field :y, :integer, primary_key: true
    field :color, :string
    belongs_to :drawing, Draw.Drawing, type: :binary_id, primary_key: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:drawing_id, :x, :y, :color])
    |> validate_required([:drawing_id, :x, :y, :color])
  end
end
