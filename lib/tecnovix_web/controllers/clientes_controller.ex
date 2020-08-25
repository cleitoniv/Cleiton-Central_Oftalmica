defmodule TecnovixWeb.ClientesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ClientesModel
  alias Tecnovix.ClientesModel
  alias Tecnovix.UsuariosClienteModel
  alias Tecnovix.AtendPrefClienteModel
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.ClientesSchema

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
    |> IO.inspect
  end

  def run(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{success: true}))
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

  def current_user(conn, _params) do
    {:ok, user} = conn.private.auth

    case user do
      %UsuariosClienteSchema{} ->
        conn
        |> put_view(TecnovixWeb.UsuariosClienteView)
        |> render("show.json", %{item: user})
      %ClientesSchema{} ->
        conn
        |> put_view(TecnovixWeb.ClientesView)
        |> render("show.json", %{item: user})
    end
  end
end
