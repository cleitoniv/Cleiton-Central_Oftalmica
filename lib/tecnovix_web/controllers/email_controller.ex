defmodule Tecnovix.Email do
  import Bamboo.Email
  alias Tecnovix.Mailer

  @remetente Application.fetch_env!(:tecnovix, :remetente)

  def send_email(to) do
    content_email(to)
    |> Mailer.deliver_now(response: true)
  end

  def content_email(email) do
    new_email(
      from: @remetente,
      to: email,
      subject: "Central Oftalmica",
      text_body: "Senha de acesso " <> Tecnovix.Repo.generate_event_id()
    )
  end

  #enviando email para o cliente de devolucao
  def send_email_dev(to, cliente_email) do
    email = content_email_dev([to, cliente_email])

    {:ok, email}
  end

  def content_email_dev(emails) do
      for email <- emails do
        new_email(
        from: @remetente,
        to: email,
        subject: "Central Oftalmica - Pedido de Devolução",
        text_body: "teste"
        )
        |> Mailer.deliver_now(response: true)
      end
  end
end
