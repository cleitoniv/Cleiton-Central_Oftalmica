defmodule TecnovixWeb.Auth.Firebase do
  @moduledoc """
  Autentica o usuario do Firebase. Esta no formato de Plug

  `
  import TecnovixWeb.Auth.Firebase
  #...
  pipeline "api" do
    plug :firebase_auth
  end
  `
  """

  use Plug.Builder

  @public_key File.read!("lib/tecnovix_web/auth/public_key.json")
              |> Jason.decode!()
              |> JOSE.JWK.from_firebase()

  @doc """
  Retira a token da request
  """
  def get_token(conn = %Plug.Conn{}) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      {:ok, token}  
    else
      _ -> {:error, :not_authorized}
    end
  end
  
  def peek(token) when is_binary(token) do
    JOSE.JWT.peek_protected(token)
  end

  def get_public_key(payload = %JOSE.JWS{}) do
    @public_key
    |> Map.keys()
    |> Enum.filter(fn key -> key == payload.fields["kid"] end)
    |> Enum.fetch(0)
  end

  def get_jwk({:ok, key}) do
      @public_key
      |> Map.get(key)
  end

  def verify_jwt(jwk, token) do
    JOSE.JWT.verify(jwk, token)
  end

  def verify_jwt({:init, token}) do
    token
    |> peek()
    |> get_public_key()
    |> get_jwk()
    |> verify_jwt(token)
  end

  def firebase_auth(conn = %Plug.Conn{}, _opts) do
    with {:ok, token} <- get_token(conn),
         {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}) do
      conn
      |> put_private(:auth, jwt)
    else
      _ -> {:error, :not_authorized}
    end
  end
end
