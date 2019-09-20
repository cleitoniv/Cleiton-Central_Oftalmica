defmodule TecnovixWeb.Auth.Firebase.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :token, :string
    field :returnSecureToken, :boolean
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:token, :returnSecureToken])
    |> validate_required([:token, :returnSecureToken])
    |> validate_inclusion(:returnSecureToken, [true])
  end
end

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
  alias TecnovixWeb.Auth.Firebase.Schema

  @endpoint "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key="
  @api_key System.get_env!("API_KEY")

  defp url() do
    @endpoint <> @api_key
  end

  def get_token(conn = %Plug.Conn{}) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      %{:ok, token: token, returnSecureToken: true}
    else
      _ -> {:error, :}
    end
  end

  def get_token(conn = %Plug.Conn{}) do
    with
      changeset =
          %Ecto.Changeset{valid: true} <- Schema.changeset(%Schema{}conn.body_params) do
        {:ok, changeset}
    else
      _ -> {:error, changeset}
    end
  end

  def call(conn = %Plug.Conn{}, _opts) do
    body = get_token(conn)
    with
      {:ok, }
      {:ok, resp, _headers} <- HTTPoison.post(url())
  end

end
