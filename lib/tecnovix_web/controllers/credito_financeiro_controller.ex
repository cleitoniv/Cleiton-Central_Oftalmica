defmodule TecnovixWeb.CreditoFinanceiroController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CreditoFinanceiroModel

  action_fallback Tecnovix.Resources.Fallback

  alias Tecnovix.{
    CreditoFinanceiroModel,
    ClientesSchema,
    UsuariosClienteSchema,
    LogsClienteModel,
    NotificacoesClienteModel
  }

  def get_creditos(conn, %{"filtro" => filtro}) do
    filtro =
      case filtro do
        nil -> 0
        _ -> String.to_integer(filtro)
      end

    with {:ok, creditos} <- CreditoFinanceiroModel.get_credito_by_status(filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("creditos.json", %{item: creditos})
    end
  end

  def insert_or_update(conn, params) do
    with {:ok, creditos} <- CreditoFinanceiroModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: creditos})
    else
      {:error, %Ecto.Changeset{} = error} -> {:error, error}
      _ -> {:error, :invalid_parameter}
    end
  end

  defp usuario_auth(auth) do
    case auth do
      nil -> ""
      usuario -> usuario
    end
  end

  def create(conn, %{"items" => params, "id_cartao" => id_cartao}) do
    {:ok, usuario} = usuario_auth(conn.private.auth_user)

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          CreditoFinanceiroModel.get_cliente_by_id(usuario.cliente_id)
      end

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, items_order} <- CreditoFinanceiroModel.items_order(params) |> IO.inspect(),
         {:ok, order} <- CreditoFinanceiroModel.order(items_order, cliente) |> IO.inspect(),
         {:ok, payment} <-
           CreditoFinanceiroModel.payment(id_cartao, order, params) |> IO.inspect(),
         {:ok, credito} <-
           CreditoFinanceiroModel.insert(params, order, payment, cliente.id) |> IO.inspect(),
         {:ok, _notifications} <-
           NotificacoesClienteModel.credit_finan_adquired(credito, cliente),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "#{credito.valor} Creditos Financeiros adicionado com sucesso."
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: credito})
    else
      _ -> {:error, :payment_not_created}
    end
  end
end
