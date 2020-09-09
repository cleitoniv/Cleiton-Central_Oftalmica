defmodule TecnovixWeb.PedidosDeVendaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PedidosDeVendaModel
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.App.Screens

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
         {:ok, _payment} <- PedidosDeVendaModel.payment(%{"id_cartao" => id_cartao}, order),
         {:ok, pedido} <-
           PedidosDeVendaModel.create_pedido(items, cliente, order, %{
             "type" => "A",
             "operation" => "Avulso"
           }) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedidos.json", %{item: pedido})
    else
      v ->
        IO.inspect(v)
        {:error, :order_not_created}
    end
  end

  def credito_produto(conn, %{"items" => items}) do
    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          PedidosDeVendaModel.get_cliente_by_id(usuario.cliente_id)
      end

    with {:ok, pedido} <-
           PedidosDeVendaModel.create_credito_produto(items, cliente, %{
             "type" => "C",
             "operation" => "Remessa"
           }) do
          conn
          |> put_status(200)
          |> put_resp_content_type("application/json")
          |> render("pedidos.json", %{item: pedido})
    else
      _ ->
        {:error, :order_not_created}
    end
  end

  def credito_financeiro(conn, %{"items" => items}) do
    {:ok, cliente} =
        case conn.private.auth do
          {:ok, %ClientesSchema{} = cliente} ->
            {:ok, cliente}

            {:ok, %UsuariosClienteSchema{} = usuario} ->
              PedidosDeVendaModel.get_cliente_by_id(usuario.cliente_id)
        end

        with {:ok, pedido} <- PedidosDeVendaModel.create_credito_financeiro(items, cliente, %{"type" => "A", "operation" => "Remessa"}) do
            conn
            |> put_status(200)
            |> put_resp_content_type("application/json")
            |> render("pedidos.json", %{item: pedido})
        else
          _ -> {:error, :order_not_created}
        end

  end

  def detail_order_id(conn, %{"id" => pedido_id}) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, pedido} <- stub.get_pedido_id(pedido_id, cliente.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: pedido}))
    else
      _ -> {:error, :not_found}
    end
  end
end
