defmodule Draw.Drawing do
  use Draw.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "drawings" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
