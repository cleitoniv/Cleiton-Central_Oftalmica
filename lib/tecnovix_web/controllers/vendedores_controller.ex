defmodule TecnovixWeb.VendedoresController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.VendedoresModel
  alias Tecnovix.VendedoresModel
  alias TecnovixWeb.Auth.FirebaseVendedor
  alias Tecnovix.ClientesModel
  alias Tecnovix.Endpoints.Protheus
  alias Tecnovix.App.Screens
  alias Tecnovix.Services.Auth

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, vendedor} <- VendedoresModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("vendedores.json", %{item: vendedor})
    end
  end

  def current_seller(conn, _params) do
    {:ok, seller} = conn.private.auth

    conn
    |> put_status(200)
    |> put_resp_content_type("application/json")
    |> render("vendedores.json", %{item: seller})
  end

  def create(conn, %{"param" => params}) do
    with false <- VendedoresModel.email_exist(params["email"]),
         {:ok, seller} <- VendedoresModel.create(params),
         {:ok, %{status_code: 200}} <-
           FirebaseVendedor.create_user(%{email: params["email"], password: params["password"]}) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("vendedores.json", %{item: seller})
    else
      true -> {:error, :email_invalid}
      error -> error
    end
  end

  def show_products_by_client(conn, %{"current_client" => current_client, "filtro" => filtro}) do
    stub = Screens.stub()
    protheus = Protheus.stub()

    with {:ok, auth} <- Auth.token(),
         {:ok, cliente} <- ClientesModel.get_client(current_client),
         {:ok, product_invoiced} <-
           Tecnovix.PedidosDeVendaModel.order_product_invoiced(cliente.id),
         {:ok, products} <-
           protheus.get_client_products(%{
             cliente: cliente.codigo,
             loja: cliente.loja,
             count: 50,
             token: auth["access_token"]
           }),
         {:ok, grid, filters} <-
           stub.get_product_grid(products, cliente, filtro, product_invoiced) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{success: true, data: grid, filters: filters})
      )
    else
      _ -> {:error, :not_found}
    end
  end

  @spec get_all_clients_by_seller(Plug.Conn.t(), any) :: Plug.Conn.t()
  def get_all_clients_by_seller(conn, _params) do
    {:ok, seller} = conn.private.auth

    with {:ok, clients} <- ClientesModel.get_all_clients_by_seller(seller.codigo) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> put_view(TecnovixWeb.ClientesView)
      |> render("clientes_seller.json", %{clientes: clients})
    end
  end

  def get_orders_by_clients(conn, %{"filtro" => filtro, "id" => id}) do
    stub = Screens.stub()

    with {:ok, pedidos} <- stub.get_detail_order(%{id: id}, filtro) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: pedidos}))
    end
  end
end
