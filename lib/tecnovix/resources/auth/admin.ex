defmodule TecnovixWeb.Auth.Commom do
  @moduledoc """
  Modulo responsavel por autenticacao interna.

  ## Usage

    `
    pipeline "api" do
      plug :commom_auth
    end
    `
  """

  use Plug.Builder

  @salt System.fetch_env!("SALT")
  @exp 3_600

  @doc false
  def get_token(conn = %Plug.Conn{}) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      {:ok, token}
    else
      _ -> {:error, :invalid}
    end
  end

  @doc """
  Autenticacao interna. Adicionar o caso de `{:error, :invalid}` no fallback para evitar possiveis erros
  com status 500.
  """
  def commom_auth(conn = %Plug.Conn{}, _opts) do
    with {:ok, token} <- get_token(conn),
         {:ok, user} <- Phoenix.Token.verify(TecnovixWeb.Endpoint, @salt, token, max_age: @exp) do
      put_private(conn, :auth, user)
    else
      error ->
        halt(conn)
        error
    end
  end
end
