defmodule Tecnovix.Resources.Fallback do
  use TecnovixWeb, :controller

  def call(conn, {:error, :expired}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Token expirado."}))
    |> halt()
  end

  def call(conn, {:errorPayment, mensagemError}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => mensagemError}))
    |> halt()
  end

  def call(conn, {:error, :type_devolution_credit}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "success" => false,
        "data" => "Modo de devolução está no modo crédito para essa operação."
      })
    )
    |> halt()
  end

  def call(conn, {:error, :phone_existing}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "success" => false,
        "data" => "Esse telefone já existe."
      })
    )
    |> halt()
  end

  def call(conn, {:error, :service_fail}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "success" => false,
        "data" => "Falha no serviço, por favor tente mais tarde."
      })
    )
    |> halt()
  end

  def call(conn, {:error, :invalid_code_sms}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Código Inválido."}))
    |> halt()
  end

  def call(conn, {:error, :product_repeated}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Esse número de série ja consta na listagem."})
    )
    |> halt()
  end

  def call(conn, {:error, :invalid}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Get token invalido."}))
    |> halt()
  end

  def call(conn, {:error, :email_invalid}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Email Existente."}))
    |> halt()
  end

  def call(conn, {:error, :email_fail}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Esse usuario não pode redefinir senha."}))
    |> halt()
  end

  def call(conn, {:error, :cliente_desativado}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Cliente desativado."}))
    |> halt()
  end

  def call(conn, {:error, :product_serial_error}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Error na serie do produto."})
    )
    |> halt()
  end

  def call(conn, {:error, :num_serie_invalid}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Número de série inválido."}))
    |> halt()
  end

  def call(conn, {:error, :serie_existente}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "success" => false,
        "data" => "Número de série já foi inserida em um processo de devolução."
      })
    )
    |> halt()
  end

  def call(conn, {:error, :not_authorized}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Não autorizado."}))
    |> halt()
  end

  def call(conn, {:error, :protheus_not_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{"success" => false, "status" => "NOT_FOUND"}))
  end

  def call(conn, {:error, :card_not_created}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Cartão não criado."}))
  end

  def call(conn, {:error, :order_not_created}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "O pedido não foi criado."}))
    |> halt()
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{"success" => false, "data" => "Não encontrado."}))
    |> halt()
  end

  def call(conn, {:error, :invalid_parameter}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Parametro inválido."}))
    |> halt()
  end

  def call(conn, {:error, :payment_not_created}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "O pagamento não foi criado."})
    )
    |> halt()
  end

  def call(conn, {:error, :inatived}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Usuario inativo."}))
    |> halt()
  end

  def call(conn, {:error, :register_error}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "data" => %{"errors" => %{"REGISTRO" => ["Erro no registro."]}},
        "success" => false
      })
    )
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    IO.inspect(changeset)

    conn
    |> put_resp_content_type("application/json")
    |> put_status(:bad_request)
    |> put_view(TecnovixWeb.ChangesetView)
    |> render("error.json", %{changeset: changeset})
  end

  def call(conn, {:error, :not_list}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Não foi possível listar os usuários."})
    )
    |> halt()
  end

  def call(conn, {:error, :cartao_not_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Cartão não encontrado."})
    )
    |> halt()
  end

  def call(conn, {:error, :pedido_failed}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Falha na criação do pedido."})
    )
    |> halt()
  end

  def call(conn, {:error, :number_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{"success" => false, "data" => "Esse número de telefone já existe."})
    )
    |> halt()
  end
end
