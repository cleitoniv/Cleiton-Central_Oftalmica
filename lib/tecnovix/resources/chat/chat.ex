defmodule Tecnovix.Chat.Channel do
  use TecnovixWeb, :channel
  alias Tecnovix.Chat.Presence

  def join("chat:" <> _id, %{"token" => _token}, socket) do
    send(self(), {:joined})
    {:ok, socket}
  end

  def handle_in("put:message", %{"body" => _body} = msg, socket) do
    msg =
      put_time(msg)
      |> put_sender(socket)
    broadcast!(socket, "incoming:message", msg)
    {:noreply, socket}
  end

  def handle_in("typing:on", _payload, socket) do
    Presence.update_user(socket, socket.assigns.user, %{typing: true})
    {:noreply, socket}
  end

  def handle_in("typing:off", _payload, socket) do
    Presence.update_user(socket, socket.assigns.user, %{typing: false})
    {:noreply, socket}
  end

  def handle_info({:joined}, socket) do
    Presence.track_user(socket, socket.assigns.user)
    {:noreply, socket}
  end

  defp put_sender(msg, socket) do
    msg
    |> Map.put(:sender, socket.assigns.user)
  end

  defp put_time(msg) when is_map(msg) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    msg
    |> Map.put("send_at", DateTime.to_string(datetime))
  end
end
