defmodule Draw.MainChannel do
  use Phoenix.Channel
  alias Draw.Presence

  def join("draw:fake_uuid", _params, socket) do
    send self(), :after_join

    {:ok, socket}
  end

  def join("draw:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("point:updated", point, socket) do
    IO.inspect(point)

    broadcast! socket, "point:updated", %{
      user: socket.assigns.user,
      x: point["x"],
      y: point["y"],
      color: point["color"],
      timestamp: :os.system_time(:milli_seconds)
    }

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    {:noreply, socket}
  end
end
