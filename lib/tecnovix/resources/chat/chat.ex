defmodule Tecnovix.Chat.Channel do
  @moduledoc false
  
  use TecnovixWeb, :channel
  alias Tecnovix.Chat.Presence

  # Loga em uma sala de chat
  def join("chat:" <> _id, %{"token" => _token}, socket) do
    send(self(), {:joined})
    {:ok, socket}
  end

  # Callback para registrar uma mensagem
  def handle_in("put:message", %{"body" => _body} = msg, socket) do
    msg =
      put_time(msg)
      |> put_sender(socket)
    broadcast!(socket, "incoming:message", msg)
    {:noreply, socket}
  end

  # Registra se o usuario esta digitando
  def handle_in("typing:on", _payload, socket) do
    Presence.update_user(socket, socket.assigns.user, %{typing: true})
    {:noreply, socket}
  end

  # Registra se o usuario nao esta mais digitando
  def handle_in("typing:off", _payload, socket) do
    Presence.update_user(socket, socket.assigns.user, %{typing: false})
    {:noreply, socket}
  end

  # Usuario começa a ser monitorado pelo Presence do Phoenix
  def handle_info({:joined}, socket) do
    Presence.track_user(socket, socket.assigns.user)
    {:noreply, socket}
  end

  # Insere o remetente da mensagem
  defp put_sender(msg, socket) do
    msg
    |> Map.put(:sender, socket.assigns.user)
  end

  # Insere a hora do envio da mensagem
  defp put_time(msg) when is_map(msg) do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    msg
    |> Map.put("send_at", DateTime.to_string(datetime))
  end
end
