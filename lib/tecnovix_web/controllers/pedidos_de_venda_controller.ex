defmodule TecnovixWeb.PedidosDeVendaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PedidosDeVendaModel
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, pedido} <- PedidosDeVendaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedidos.json", %{item: pedido})
    end
  end

  def create(conn, %{"items" => items, "id_cartao" => id_cartao}) do
    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          PedidosDeVendaModel.get_cliente_by_id(usuario.cliente_id)
      end

    with {:ok, items_order} <- PedidosDeVendaModel.items_order(items),
         {:ok, order} <- PedidosDeVendaModel.order(items_order, cliente),
         {:ok, pedido} <- PedidosDeVendaModel.create_pedido(items, cliente, order),
         {:ok, payment} <- PedidosDeVendaModel.payment(%{"id_cartao" => id_cartao}, order) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true, data: Jason.decode!(payment.body)}))
    else
      v ->
        IO.inspect(v)
        {:error, :order_not_created}
    end
  end
end
