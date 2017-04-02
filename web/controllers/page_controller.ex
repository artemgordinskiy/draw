defmodule Draw.PageController do
  use Draw.Web, :controller

  alias Draw.Drawing

  def index(conn, _params) do
    last_drawings = Repo.all(
      from d in Drawing,
      select: %{id: d.id, name: d.name},
      limit: 10,
      order_by: [desc: d.inserted_at]
    )

    render conn, "index.html", drawings: last_drawings
  end
end
