defmodule TecnovixWeb.PedidosDeVendaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PedidosDeVendaModel

  alias Tecnovix.{
    PedidosDeVendaModel,
    ClientesSchema,
    UsuariosClienteSchema,
    App.Screens,
    LogsClienteModel,
    NotificacoesClienteModel
  }

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, pedido} <- PedidosDeVendaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
    else
      _ -> {:error, :order_not_created}
    end
  end

  # boleto
  def create_boleto(conn, %{"items" => items, "parcela" => parcela}) do
    {:ok, usuario} = usuario_auth(conn.private.auth_user)

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          PedidosDeVendaModel.get_cliente_by_id(usuario.cliente_id)
      end

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, pedido} <- PedidosDeVendaModel.create_pedido(items, cliente, parcela),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Pedido solicitado com boleto feito com sucesso."
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
    end
  end

  # credit_card
  def create(conn, %{"items" => items, "id_cartao" => id_cartao}) do
    {:ok, usuario} = usuario_auth(conn.private.auth_user)

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          PedidosDeVendaModel.get_cliente_by_id(usuario.cliente_id)
      end

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, items_order} <- PedidosDeVendaModel.items_order(items),
         {:ok, order} <- PedidosDeVendaModel.order(items_order, cliente),
         {:ok, payment} <-
           PedidosDeVendaModel.payment(%{"id_cartao" => id_cartao}, order),
         {:ok, pedido} <- PedidosDeVendaModel.create_pedido(items, cliente, order, 1),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Pedido feito com o cartão de crédito com sucesso."
           ),
         {:ok, notificacao} <- NotificacoesClienteModel.verify_notification(pedido, cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
    end
  end

  defp usuario_auth(auth) do
    case auth do
      nil -> ""
      usuario -> usuario
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

    with {:ok, pedido} <-
           PedidosDeVendaModel.create_credito_financeiro(items, cliente, %{
             "type" => "A",
             "operation" => "Remessa"
           }) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
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

  def get_pedidos(conn, %{"filtro" => filtro, "nao_integrado" => nao_integrado}) do
    with {:ok, pedidos} <- PedidosDeVendaModel.get_pedidos_protheus(filtro, nao_integrado) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedidos_protheus.json", %{item: pedidos})
    else
      _ -> {:error, :not_found}
    end
  end

  def get_pedidos(conn, %{"filtro" => filtro}) do
    with {:ok, pedidos} <- PedidosDeVendaModel.get_pedidos_protheus(filtro, nil) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedidos_protheus.json", %{item: pedidos})
    else
      _ -> {:error, :not_found}
    end
  end
end
