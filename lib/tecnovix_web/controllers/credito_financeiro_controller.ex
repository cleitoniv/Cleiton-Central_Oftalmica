defmodule TecnovixWeb.CreditoFinanceiroController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CreditoFinanceiroModel

  alias Tecnovix.{
    CreditoFinanceiroModel,
    ClientesSchema,
    UsuariosClienteSchema,
    LogsClienteModel,
    NotificacoesClienteModel
  }

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

    with {:ok, items_order} <- CreditoFinanceiroModel.items_order(params),
         {:ok, order} <- CreditoFinanceiroModel.order(items_order, cliente),
         {:ok, payment} <- CreditoFinanceiroModel.payment(id_cartao, order, params),
         {:ok, credito} <- CreditoFinanceiroModel.insert(params, order, payment, cliente.id),
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
    end
  end
end
