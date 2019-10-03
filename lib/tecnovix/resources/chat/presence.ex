defmodule Tecnovix.Chat.Presence do
  @moduledoc false

  use Phoenix.Presence, otp_app: :tecnovix, pubsub_server: Tecnovix.PubSub
  alias Tecnovix.Chat.Presence

  # Wrapper do Prese para tracking do usuario
  def track_user(socket, user) do
    Presence.track(socket, user.uid, %{
      typing: false,
      name: user.name,
      uid: user.uid
    })
  end

  # Update do usuario no Presence
  def update_user(socket, user, %{typing: typing}) do
    Presence.update(socket, user.uid, %{
      typing: typing,
      name: user.name,
      uid: user.uid
    })
  end
end
