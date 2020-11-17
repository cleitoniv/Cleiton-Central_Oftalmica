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

  def pedido_produto(conn, %{"items" => items, "valor" => valor}) when valor == 0 do
    {:ok, cliente} = conn.private.auth

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, pedido} <-
      PedidosDeVendaModel.create_pedido(items, cliente, nil, nil, nil),
    {:ok, _logs} <-
      LogsClienteModel.create(
        ip,
        nil,
        cliente,
        "Pedido feito com a remessa de contrato de produto."
      ) do
        conn
        |> put_status(200)
        |> put_resp_content_type("application/json")
        |> render("pedido.json", %{item: pedido})
    end
  end

  def pedido_produto(conn, _params) do
    {:error, :order_not_created}
  end

  def pacientes_revisao(conn, _params) do
    {:ok, cliente} = conn.private.auth

    with {:ok, revisao} <- PedidosDeVendaModel.get_pacientes_revisao(cliente.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: revisao})
    end
  end

  def taxa_entrega(conn, _params) do
    with {:ok, taxa_entrega} <- PedidosDeVendaModel.taxa_entrega() do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: taxa_entrega}))
    end
  end

  def taxa(conn, %{"valor" => valor}) do
    valor = String.to_integer(valor)

    with {:ok, parcelas} <- PedidosDeVendaModel.parcelas(),
         {:ok, valores} <- PedidosDeVendaModel.taxa(valor, parcelas) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: valores}))
    end
  end

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
  def create_boleto(conn, %{
        "items" => items,
        "installment" => installment,
        "taxa_entrega" => taxa_entrega
      }) do
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

    with {:ok, pedido} <-
           PedidosDeVendaModel.create_pedido(items, cliente, installment, taxa_entrega),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Pedido feito em #{installment}x e com R$ #{taxa_entrega / 100} de pagamento no frete, no boleto."
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
    end
  end

  # credit_card
  def create(
        conn,
        %{
          "items" => items,
          "id_cartao" => id_cartao,
          "ccv" => ccv,
          "installment" => installment,
          "taxa_entrega" => taxa_entrega
        } = params
      )
      when is_nil(ccv) == false and is_nil(id_cartao) == false do
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

    taxa_entrega =
      case taxa_entrega do
        nil -> 0
        taxa_entrega -> taxa_entrega
      end

    with {:ok, items_order} <- PedidosDeVendaModel.items_order(items),
         {:ok, order} <-
           PedidosDeVendaModel.order(items_order, cliente, taxa_entrega, installment),
         {:ok, payment} <-
           PedidosDeVendaModel.payment(%{"id_cartao" => id_cartao}, order, ccv, installment),
         {:ok, pedido} <-
           PedidosDeVendaModel.create_pedido(items, cliente, order, installment, taxa_entrega),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Pedido feito em #{installment}x e com R$ #{taxa_entrega / 100} de pagamento no frete, no crédito."
           ),
         {:ok, notificacao} <- NotificacoesClienteModel.verify_notification(pedido, cliente) do
      # IO.inspect Jason.decode!(order.body)
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("pedido.json", %{item: pedido})
    else
      _ -> {:error, :order_not_created}
    end
  end

  def create(conn, params) do
    {:error, :order_not_created}
  end

  defp usuario_auth(auth) do
    case auth do
      nil -> ""
      usuario -> usuario
    end
  end

  def detail_order_id(conn, %{"id" => pedido_id, "item_pedido" => item_pedido}) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, pedido} <- stub.get_pedido_id(pedido_id, cliente.id, item_pedido) do
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
