defmodule Tecnovix.Resources.Fallback do
  use TecnovixWeb, :controller

  def call(conn, {:error, :expired}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Token expirado."}))
    |> halt()
  end

  def call(conn, {:error, :cliente_desativado}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Cliente desativado."}))
    |> halt()
  end

  def call(conn, {:error, :not_authorized}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Cliente não autorizado."}))
    |> halt()
  end

  def call(conn, {:error, :protheus_not_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{"status" => "NOT_FOUND"}))
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
    |> send_resp(404, Jason.encode!(%{"success" => false, "data" => "Recurso não encontrado."}))
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
    |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Erro no registro."}))
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
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
end
