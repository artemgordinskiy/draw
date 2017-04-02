defmodule Draw.NewDrawingController do
  use Draw.Web, :controller

  alias Draw.{Drawing, Repo}

  def index(conn, _params) do
    render conn, "index.html", changeset: Drawing.changeset(%Drawing{}),
           action: "/new-drawing/submit"
  end

  def submit(conn, %{"drawing" => drawing_params}) do
    changeset = Drawing.changeset(%Drawing{}, drawing_params)

    case Repo.insert(changeset) do
      {:ok, drawing} ->
        conn
        |> put_flash(:info, "Drawing created successfully")
        |> redirect(to: "/drawing/" <> drawing.id)
      {:error, _} ->
        conn
        |> put_flash(:error, "Error creating a drawing")
        |> redirect(to: "/")
    end
  end
end
