defmodule Tecnovix.Email do
  import Bamboo.Email
  alias Tecnovix.Mailer

  @remetente Application.fetch_env!(:tecnovix, :remetente)

  def send_email(to) do
    content_email(to)
    |> Mailer.deliver_now(response: true)
  end

  def content_email(user) do
    new_email(
      from: @remetente,
      to: user,
      subject: "Central Oftalmica",
      text_body: "Senha de acesso " <> Tecnovix.Repo.generate_event_id()
    )
  end
end
