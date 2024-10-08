defmodule TecnovixWeb.Auth.Firebase do
  use TecnovixWeb, :controller

  @moduledoc """
  Autentica o usuario do Firebase. Esta no formato de Plug

  ## Usage

    `
    import TecnovixWeb.Auth.Firebase
    #...
    pipeline "api" do
      plug :firebase_auth
    end
    `
  """
  use Plug.Builder

  @firebase_api_key Application.fetch_env!(:tecnovix, :firebase_api_key_client)
  action_fallback Tecnovix.Resources.Fallback

  def get_firebase_keys() do
    with {:ok, resp} <-
           HTTPoison.get(
             "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
           ) do
      {:ok,
       Jason.decode!(resp.body)
       |> JOSE.JWK.from_firebase()}
    else
      _ -> {:error, :not_authorized}
    end
  end

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

  @doc """
  Retira a parte protegida da token em forma de %JOSE.JWS{}.
  """
  def peek(token) when is_binary(token) do
    JOSE.JWT.peek_protected(token)
  end

  @doc """
  Identifica a public key usada para gerar a IdToken passada.
  """
  def get_public_key(payload = %JOSE.JWS{}) do
    with {:ok, public_keys} <- get_firebase_keys() do
      public_keys
      |> Map.keys()
      |> Enum.filter(fn key -> key == payload.fields["kid"] end)
      |> Enum.fetch(0)
      |> get_jwk(public_keys)
    end
  end

  @doc """
  Após a identificacao da chave publica, retorna a JWK referente para verificar a token
  """
  def get_jwk({:ok, key}, firebase) do
    firebase
    |> Map.get(key)
  end

  def verify_jwt(jwk, token) do
    JOSE.JWT.verify(jwk, token)
  end

  @doc """
  Verifica a JWT passada na requisiçao.

  Retorna `{true, %JOSE.JWT{}, %JOSE.JWS{}}` para tokens validas
  """
  def verify_jwt({:init, token}) do
    token
    |> peek()
    |> get_public_key()
    |> verify_jwt(token)
  end

  @doc """
  Plug para autenticacao com o firebase. Sempre lembrar de adicionar o caso de `{:error, :not_authorized}`
  no Fallback do router.
  Caso contrario para o resto do lifecycle da requisiçao, os dados do JWT estaram na key `:auth` do campo
  private da `%Plug.Conn{}`.
  """
  def firebase_auth(conn = %Plug.Conn{}, _opts) do
    with {:ok, token} <- get_token(conn),
         {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}) do
      put_private(conn, :auth, {:ok, jwt})
    else
      _ ->
        halt(conn)
        {:error, :not_authorized}
    end
  end

  def cliente_auth(conn = %Plug.Conn{}, _opts) do
    with {:ok, token} <- get_token(conn),
         {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}),
         {:ok, user} <- Tecnovix.ClientesModel.search_register_email(jwt.fields["email"]),
         true <- user.sit_app != "D" do
      put_private(conn, :auth, {:ok, user})
      |> put_private(:auth_user, {:ok, nil})
    else
      false ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{"success" => false, "data" => "Cliente desativado."}))
        |> halt()

      _ ->
        conn
        |> user_cliente_auth(nil)
    end
  end

  def user_cliente_auth(conn, _opts) do
    with {:ok, token} <- get_token(conn),
         {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}),
         {:ok, user} <- Tecnovix.UsuariosClienteModel.search_register_email(jwt.fields["email"]) do
      user = Tecnovix.Repo.preload(user, :cliente)

      put_private(conn, :auth, {:ok, user.cliente})
      |> put_private(:auth_user, {:ok, user})
    else
      _ ->
        halt(conn)
        {:error, :not_authorized}
    end
  end

  @doc false
  def create_user(%{email: _email, password: _password} = params) do
    params = Map.put(params, :returnSecureToken, true)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" <> @firebase_api_key
    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  def reset_password(%{email: _email} = params) do
    params = Map.put(params, :requestType, "PASSWORD_RESET")
    url = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=" <> @firebase_api_key
    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  @doc false
  def sign_in(%{email: _email, password: _password} = params) do
    params = Map.put(params, :returnSecureToken, true)

    url =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" <>
        @firebase_api_key

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  def update_profile(%{idToken: _idToken, displayName: _displayName} = params) do
    params = Map.put(params, :returnSecureToken, true)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=" <> @firebase_api_key
    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  def update_password(%{idToken: _idToken, password: _password} = params) do
    params = Map.put(params, :returnSecureToken, true)

    url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=" <> @firebase_api_key

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  def delete_user_firebase(%{idToken: _idToken} = params) do
    url = "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=" <> @firebase_api_key

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end

  def send_reset_password(%{email: email} = params) do
    url = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=" <> @firebase_api_key

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end
end
