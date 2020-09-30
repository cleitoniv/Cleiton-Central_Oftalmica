defmodule Tecnovix.Email do
  import Bamboo.Email
  alias Tecnovix.Mailer

  @remetente Application.fetch_env!(:tecnovix, :remetente)

  def send_email(to, senha) do
    content_email(to, senha)
    |> Mailer.deliver_now(response: true)
  end

  def content_email(email, senha) do
    new_email(
      from: @remetente,
      to: email,
      subject: "Central Oftalmica",
      html_body: {TecnovixWeb.LayoutView, "email_senha_html.eex"},
      text_body: "Senha de acesso " <> senha
    )
  end

  # enviando email para o cliente de devolucao
  def send_email_dev(email) do
    email =
      content_email_dev(email)
      |> Mailer.deliver_now(response: true)

    {:ok, email}
  end

  def content_email_dev(email) do
    new_email(
      from: @remetente,
      to: email,
      subject: "Central Oftalmica - Pedido de Devolução",
      text_body: "teste"
    )
  end
end
