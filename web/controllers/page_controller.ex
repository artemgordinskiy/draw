defmodule Draw.PageController do
  use Draw.Web, :controller

  alias Draw.Drawing

  def index(conn, _params) do
    render conn, "index.html", changeset: Drawing.changeset(%Drawing{}),
           action: "/new-drawing/submit"
  end
end
