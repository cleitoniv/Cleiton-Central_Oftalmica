defmodule TecnovixWeb.CreditoFinanceiroController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  def create(conn, %{"items" => params, "id_cartao" => id_cartao}) do
    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          CreditoFinanceiroModel.get_cliente_by_id(usuario.cliente_id)
      end

    with {:ok, items_order} <- CreditoFinanceiroModel.items_order(params),
         {:ok, order} <- CreditoFinanceiroModel.order(items_order, cliente),
         {:ok, payment} <- CreditoFinanceiroModel.payment(id_cartao, order, params),
         {:ok, credito} <- CreditoFinanceiroModel.insert(params, order, payment, cliente.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: credito})
    end
  end
end
