defmodule TecnovixWeb.ClientesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ClientesModel
  alias Tecnovix.ClientesModel
  alias Tecnovix.UsuariosClienteModel
  alias Tecnovix.AtendPrefClienteModel
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.ClientesSchema
  alias Tecnovix.App.Screens

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, cliente} <- ClientesModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("clientes.json", %{item: cliente})
    end
  end

  def first_acess(conn, %{"param" => params}) do
    with {:ok, cliente} <- ClientesModel.create_first_acess(params) do
      conn
      |> put_status(201)
      |> put_resp_content_type("application/json")
      |> render("clientes.json", %{item: cliente})
    end
  end

  def create_user(conn, %{"param" => params}) do
    {:ok, jwt} = conn.private.auth
    params = Map.put(params, "email", jwt.fields["email"])
    params = Map.put(params, "uid", jwt.fields["user_id"])
    __MODULE__.create(conn, %{"param" => params})
  end

  def show(conn, _params) do
    case conn.private.auth do
      {:ok, %Tecnovix.ClientesSchema{} = cliente} ->
        {:ok, map} = ClientesModel.show(cliente.id)

        user =
          Map.put(map, :atend_pref_cliente, AtendPrefClienteModel.get_by(cliente_id: cliente.id))

        conn
        |> put_status(:ok)
        |> put_resp_content_type("applicaton/json")
        |> put_view(TecnovixWeb.ClientesView)
        |> render("show_cliente.json", %{item: user})

      {:ok, %Tecnovix.UsuariosClienteSchema{} = usuario} ->
        {:ok, map} = UsuariosClienteModel.show(usuario.id)

        user =
          Map.put(map, :cliente, ClientesModel.get_by(id: usuario.cliente_id))
          |> Map.put(
            :atend_pref_cliente,
            AtendPrefClienteModel.get_by(cliente_id: usuario.cliente_id)
          )

        conn
        |> put_status(:ok)
        |> put_resp_content_type("applicaton/json")
        |> put_view(TecnovixWeb.ClientesView)
        |> render("show_usuario.json", %{item: user})

      _ ->
        {:error, :invalid_parameter}
    end
  end

  def get_clientes_app(conn, %{"filtro" => filtro}) do
    with {:ok, clientes} <- ClientesModel.get_clientes_app(filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("app_clientes.json", %{clientes: clientes})
    else
      _ ->
        {:error, :invalid_parameter}
    end
  end

  def current_user(conn, _params) do
    {:ok, user} = conn.private.auth

    case user do
      %UsuariosClienteSchema{} ->
        conn
        |> put_view(TecnovixWeb.UsuariosClienteView)
        |> render("show.json", %{item: user})

      %ClientesSchema{} ->
        stub = Screens.stub()

        credits_info = stub.get_credits(user)
        notifications = stub.get_notifications_open(user)

        conn
        |> put_view(TecnovixWeb.ClientesView)
        |> render("current_user.json", %{
          item: user,
          credits: credits_info,
          notifications: notifications
        })
    end
  end

  def products(conn, %{"filtro" => filtro}) do
    filtro =
      case filtro do
        "Todos" -> "all"
        "Miopía" -> "miopia"
        "Hipermetropia" -> "hipermetropia"
      end

    stub = Screens.stub()

    {:ok, cliente} = conn.private.auth

    with {:ok, product} <- stub.get_product_grid(cliente, filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: product}))
    end
  end

  def offers(conn, _params) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, offers} <- stub.get_offers(cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: offers}))
    end
  end

  def products_credits(conn, _params) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, products} <- stub.get_products_credits(cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: products}))
    end
  end

  def orders(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, orders} <- stub.get_order(cliente, filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: orders}))
    end
  end

  def cart(conn, _params) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, cart} <- stub.get_products_cart(cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: cart}))
    end
  end

  def info_product(conn, %{"id" => id}) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, info} <- stub.get_info_product(cliente, id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: info}))
    end
  end

  def detail_order(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()
    {:ok, cliente} = conn.private.auth

    with {:ok, detail} <- stub.get_detail_order(cliente, filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: detail}))
    end
  end

  def get_cards(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          ClientesModel.get_cliente(usuario.cliente_id)
      end

    with {:ok, cards} <- stub.get_cards(cliente) do
      conn
      |> put_status(200)
      |> put_view(TecnovixWeb.CartaoCreditoClienteView)
      |> put_resp_content_type("application/json")
      |> render("cards.json", %{item: cards})
    end
  end

  def get_payments(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()

    {:ok, cliente} = conn.private.auth

    with {:ok, payments} <- stub.get_payments(cliente, filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: payments}))
    end
  end

  def get_mypoints(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} = conn.private.auth

    with {:ok, pedidos_points} <- stub.get_mypoints(cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: pedidos_points}))
    end
  end
end
