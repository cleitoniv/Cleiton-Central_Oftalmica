defmodule TecnovixWeb.ContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContratoDeParceriaModel
  alias Tecnovix.{ContratoDeParceriaModel, UsuariosClienteSchema, NotificacoesClienteModel, Services.Auth}
  alias Tecnovix.Endpoints.Protheus
  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, contrato} <- ContratoDeParceriaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    end
  end

  def verify_auth({:ok, cliente}) do
    case cliente do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(cliente, :cliente)
        {:ok, user.cliente}

      v ->
        {:ok, v}
    end
  end

  def create(conn, %{
        "items" => items,
        "id_cartao" => id_cartao,
        "ccv" => ccv,
        "installment" => installment
      }) do
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, items_order} <- ContratoDeParceriaModel.items_order(items),
         {:ok, order} <- ContratoDeParceriaModel.order(cliente, items_order),
         {:ok, _payment} <- ContratoDeParceriaModel.payment(id_cartao, order, ccv, installment),
         {:ok, contrato} <-
           ContratoDeParceriaModel.create_contrato(cliente, items, order),
         {:ok, _notifications} <-
           NotificacoesClienteModel.credit_product_adquired(contrato, cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    else
      _ -> {:error, :order_not_created}
    end
  end

  def get_package(conn, %{"grupo" => grupo}) do
    {:ok, cliente} = conn.private.auth
    protheus = Protheus.stub()

    with  {:ok, auth} <- Auth.token(),
          {:ok, resp} <- protheus.get_contract_table(%{cliente: cliente.codigo, loja: cliente.loja, grupo: grupo}, auth["access_token"]),
          {:ok, pacotes} <- ContratoDeParceriaModel.get_package(resp) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: pacotes}))
    end
  end
end
