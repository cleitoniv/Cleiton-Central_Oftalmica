defmodule Tecnovix.Chat.Presence do
  use Phoenix.Presence, otp_app: :tecnovix, pubsub_server: Tecnovix.PubSub
  alias Tecnovix.Chat.Presence

  def track_user(socket, user) do
    Presence.track(socket, user.uid, %{
        typing: false,
        name: user.name,
        uid: user.uid
      })
  end

  def update_user(socket, user, %{typing: typing}) do
    Presence.update(socket, user.uid, %{
        typing: typing,
        name: user.name,
        uid: user.uid
      })
  end
end
