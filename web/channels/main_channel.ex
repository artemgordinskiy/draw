defmodule Draw.MainChannel do
  use Phoenix.Channel
  alias Draw.{Presence, Drawing, Repo}

  def join("draw:" <> drawing_id, _params, socket) do
    drawing = Repo.get!(Drawing, drawing_id)
    socket = assign(socket, :drawing_id, drawing.id)

    send self(), :after_join

    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    {:noreply, socket}
  end

  def handle_in("path:started", payload, socket) do
    payload = add_broadcast_meta(payload, socket)

    broadcast! socket, "path:started", payload

    {:noreply, socket}
  end

  def handle_in("path:ended", payload, socket) do
    payload = add_broadcast_meta(payload, socket)

    broadcast! socket, "path:ended", payload

    {:noreply, socket}
  end

  def handle_in("path:point-added", payload, socket) do
    payload = add_broadcast_meta(payload, socket)

    broadcast! socket, "path:point-added", payload

    {:noreply, socket}
  end

  intercept ["path:started", "path:point-added", "path:ended"]

  @doc """
  Prevent point update events going out to the same user who made them.
  """
  def handle_out(name, message, socket) do
    unless socket.assigns[:user] == message.user do
      push socket, name, message
    end

    {:noreply, socket}
  end

  defp add_broadcast_meta(payload, socket) do
    Map.merge(
      payload,
      %{
        user: socket.assigns.user,
        timestamp: :os.system_time(:milli_seconds)
      }
    )
  end
end
