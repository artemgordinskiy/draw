defmodule Draw.DrawingController do
  use Draw.Web, :controller

  alias Draw.{Drawing, ErrorView}

  def index(conn, %{"id" => id}) do
    drawing = Repo.get(Drawing, id)

    case drawing do
      %Drawing{} ->
        render conn, "index.html", drawing: drawing
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ErrorView, "404.html")
    end
  end
end
