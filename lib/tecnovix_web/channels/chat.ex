defmodule TecnovixWeb.ChatSocket do
  use Phoenix.Socket

  channel "chat:*", Tecnovix.Chat.Channel

  def connect(%{"token" => token}, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
