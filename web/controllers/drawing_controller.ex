defmodule Draw.DrawingController do
  use Draw.Web, :controller

  alias Draw.Drawing

  def index(conn, %{"id" => id}) do
    drawing = Repo.get!(Drawing, id)

    render conn, "index.html", drawing: drawing
  end
end
