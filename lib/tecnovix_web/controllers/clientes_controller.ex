defmodule TecnovixWeb.ClientesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ClientesModel
  alias Tecnovix.ClientesModel
  alias Tecnovix.UsuariosClienteModel
  action_fallback Tecnovix.Resources.Fallback
  
  def create_user(conn, %{"param" => params}) do
    {:ok, jwt} = conn.private.auth
    params = Map.put(params, "email", jwt.fields["email"])
    __MODULE__.create(conn, %{"param" => params})
  end

  def run(conn, _params) do
    IO.inspect conn.private.auth
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{sucess: true}))
  end

  def verify_sit_app(conn, id) do
    with cliente <- ClientesModel.verify_sit_app(id) do
      cond do
        cliente.sit_app != "D" ->
          conn
          |> put_status(:ok)
          |> put_resp_content_type("application/json")
          |> put_view(TecnovixWeb.ClientesView)
          |> render("item.json", %{item: cliente})
        true ->
          conn
          |> send_resp(401, Jason.encode!(%{sucess: false, data: "Cliente desativado."}))
          |> halt()
      end
    end
  end
end
