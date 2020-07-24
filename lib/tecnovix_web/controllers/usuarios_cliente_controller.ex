defmodule TecnovixWeb.UsuariosClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.UsuariosClienteModel
  alias Tecnovix.{Auth.Firebase, Email, UsuariosClienteModel, ClientesSchema, LogsClienteModel}
  alias TecnovixWeb.LogsClienteController
  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    with {:ok, user} <- UsuariosClienteModel.create(params) do
      case Email.send_email({user.nome,user.email}) do #verificando se o email foi enviado com sucesso
        {_send, {:delivered_email, _email}} ->
        UsuariosClienteModel.update_senha(user, %{"senha_enviada" => 1}) #atualizando o campo senha_enviada para 1(indicando que o email foi enviado)
        _ ->
         {:error, :invalid_parameter}
      end
      {:ok, cliente} = conn.private.auth
      LogsClienteModel.create(
      %{
        "cliente_id" => cliente.id,
        "data" => DateTime.utc_now(),
        "ip" => "teste",
        "dispositivo" => "teste",
        "acao_realizada" => "Realizou o cadastro"
      }
      ) #registrando a acao na tabela logs_cliente
      conn
      |> put_status(:created)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: user})
    end
  end

  def update_users(conn, %{"id" => id, "param" => params}) do
    {:ok, cliente} = conn.private.auth
    with {:ok, user} <- UsuariosClienteModel.search_user(id),
         user.cliente_id == cliente.id,
         {:ok, user} <- UsuariosClienteModel.update(user, params) do
            conn
            |> put_status(:ok)
            |> put_resp_content_type("application/json")
            |> render("show.json", %{item: user})
      else
        _ -> {:error, :invalid_parameter}
    end
  end

  def create_user(conn, %{"param" => params}) do
    case conn.private.auth do
      {:ok, %ClientesSchema{} = user} ->
        params = Map.put(params, "cliente_id", user.id)
        __MODULE__.create(conn, %{"param" => params})
      _ ->
      {:error, :invalid_parameter}
    end
  end
end
