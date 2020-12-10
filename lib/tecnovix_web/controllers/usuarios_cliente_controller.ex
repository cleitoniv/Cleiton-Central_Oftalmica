defmodule TecnovixWeb.UsuariosClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.UsuariosClienteModel
  alias Tecnovix.{Email, UsuariosClienteModel, ClientesSchema, LogsClienteModel}
  alias TecnovixWeb.{Auth.Firebase}

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth
    {:ok, usuario} = conn.private.auth_user

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, authorized} <- UsuariosClienteModel.unique_email(params),
         {:ok, %{status_code: 200}} <-
           Firebase.create_user(%{email: params["email"], password: params["password"]}),
         {:ok, user} <- UsuariosClienteModel.create(params),
         {_, %{status_code: code}} when code == 200 or code == 202 <-
           Email.send_email({user.nome, user.email}, params["password"], params["nome"]),
         {:ok, _logs} <- LogsClienteModel.create(ip, usuario, cliente, "Usuario cliente #{user.nome} cadastrado.") do
      UsuariosClienteModel.update_senha(user, %{"senha_enviada" => 1})

      conn
      |> put_status(:created)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: user})
    else
      {:error, %Ecto.Changeset{} = error} ->
        {:error, error}

      {:ativo, user} ->
          conn
          |> put_status(:created)
          |> put_resp_content_type("application/json")
          |> render("show.json", %{item: user})

      _ -> {:error, :invalid_parameter}
    end
  end

  def update_users(conn, %{"id" => id, "param" => params}) do
    {:ok, cliente} = conn.private.auth
    {:ok, usuario} = conn.private.auth_user

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, user} <- UsuariosClienteModel.search_user(id),
         true <- user.cliente_id == cliente.id,
         {:ok, user} <- UsuariosClienteModel.update(user, params),
         {:ok, _logs} <- LogsClienteModel.create(ip, usuario, cliente, "Atualizou o usuário #{user.nome}") do
      {:ok, cliente} = conn.private.auth

      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: user})
    else
      _ -> {:error, :invalid_parameter}
    end
  end

  def delete_users(conn, %{"id" => id} = params) do
    id = String.to_integer(id)
    {:ok, cliente} = conn.private.auth
    {:ok, usuario} = conn.private.auth_user

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, token} <- Firebase.get_token(conn),
         {:ok, user} <- UsuariosClienteModel.delete_users(id, cliente),
         {:ok, _logs} <- LogsClienteModel.create(ip, usuario, cliente, "Usuario cliente #{user.nome} deletado") do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    else
      _ -> {:error, :not_found}
    end
  end

  def create_user(conn, %{"param" => params}) do
    params = Map.put(params, "password", String.slice(Tecnovix.Repo.generate_event_id(), 6..11))

    case conn.private.auth do
      {:ok, %ClientesSchema{} = user} ->
        params = Map.put(params, "cliente_id", user.id)
        __MODULE__.create(conn, %{"param" => params})

      _ ->
        {:error, :invalid_parameter}
    end
  end

  def cliente_index(conn, params) do
    {:ok, cliente} = conn.private.auth

    params =
      Map.put(params, "cliente_id", cliente.id)
      |> Map.put("status", 1)

    __MODULE__.index(conn, params)
  end
end
