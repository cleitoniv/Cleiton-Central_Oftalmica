defmodule TecnovixWeb.SyncUsersController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.SyncUsersModel
  alias Tecnovix.SyncUsersModel

  action_fallback Tecnovix.Resources.Fallback

  @salt Application.fetch_env!(:tecnovix, :sync_users_salt)
  @sync_users_salt Application.fetch_env!(:tecnovix, :sync_users_salt)

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, user} <- SyncUsersModel.get_by_username(username),
         true <- Bcrypt.verify_pass(password, user.password_hash) do
      token = Phoenix.Token.sign(TecnovixWeb.Endpoint, @salt, %{type: "token", user_id: user.id})
      refresh_token = Phoenix.Token.sign(TecnovixWeb.Endpoint, @salt, "refresh_token")

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{access_token: token, refresh_token: refresh_token, expires_in: 3_600})
      )
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{"message" => "Credenciais ou token inválido"}))
        |> halt()
    end
  end

  def login(conn, %{"refresh_token" => refresh_token}) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(TecnovixWeb.Endpoint, @sync_users_salt, refresh_token,
             max_age: 60
           ) do
      token =
        Phoenix.Token.sign(TecnovixWeb.Endpoint, @salt, %{type: "refresh", user_id: user_id})

      refresh_token = Phoenix.Token.sign(TecnovixWeb.Endpoint, @salt, "refresh_token")

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{access_token: token, refresh_token: refresh_token, expires_in: 3_600 * 12})
      )
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{"message" => "Credenciais ou token inválido"}))
        |> halt()
    end
  end

  def run(conn, _) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{"message" => "ok"}))
  end
end
