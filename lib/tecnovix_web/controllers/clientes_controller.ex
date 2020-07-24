defmodule TecnovixWeb.ClientesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ClientesModel
  alias Tecnovix.ClientesModel
  alias Tecnovix.UsuariosClienteModel
  action_fallback Tecnovix.Resources.Fallback

  def create_user(conn, %{"param" => params}) do
    {:ok, jwt} = conn.private.auth
    params = Map.put(params, "email", jwt.fields["email"])
    params = Map.put(params, "uid", jwt.fields["user_id"])
    __MODULE__.create(conn, %{"param" => params})
  end

  def run(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{sucess: true}))
  end
end
