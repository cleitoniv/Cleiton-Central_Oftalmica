defmodule TecnovixWeb.Auth.SyncUsers do
use Plug.Builder

  @sync_users_salt Application.fetch_env!(:tecnovix, :sync_users_salt)
  @exp 3_600

  def get_token(conn = %Plug.Conn{}) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :invalid}
    end
  end

  def sync_users_auth(conn = %Plug.Conn{}, _) do
    with {:ok, token} <- get_token(conn),
         {:ok, sync_user} <- verify_token(token) do
      put_private(conn, :auth, {:ok, sync_user})
    else
      error ->
        halt(conn)
        error
    end
  end

  defp verify_token(token) do
    case Phoenix.Token.verify(TecnovixWeb.Endpoint, @sync_users_salt, token, max_age: 3_600 * 200) do
      {:ok, %{type: "token"}} -> Phoenix.Token.verify(TecnovixWeb.Endpoint, @sync_users_salt, token, max_age: 3_600)
      {:ok, %{type: "refresh_token"}} -> Phoenix.Token.verify(TecnovixWeb.Endpoint, @sync_users_salt, token, max_age: 3_600 * 12)
      _ -> {:error, :not_authorized}
    end
  end
end
