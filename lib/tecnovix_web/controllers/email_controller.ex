defmodule Tecnovix.Email do
  import Bamboo.Email
  alias Tecnovix.Mailer
  require EEx

  @remetente Application.fetch_env!(:tecnovix, :remetente)
  @path "lib/tecnovix_web/template/email/email_senha.html.eex"
  EEx.function_from_file(:def, :template, @path, [:senha, :nome])

  def send_email(to, senha, nome) do
    content_email(to, senha, nome)
    |> Mailer.deliver_now(response: true)
  end

  def content_email(email, senha, nome) do
    new_email
    |> from(@remetente)
    |> to(email)
    |> subject("Central Oftalmica - Senha de acesso")
    |> html_body(template(senha, nome))
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
