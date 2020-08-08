defmodule TecnovixWeb.Support.Generator do
  alias TecnovixWeb.Auth.Firebase
  alias Tecnovix.SyncUsersModel
  import Phoenix.ConnTest
  import Plug.Conn

  @endpoint TecnovixWeb.Endpoint

  def sync_user(user, password) do
    {:ok, _} = SyncUsersModel.create(%{"username" => user, "password" => password})

    build_conn()
    |> post("/api/user_sync/login", %{"username" => user, "password" => password})
    |> json_response(200)
  end

  def logs_param() do
    %{
      "data" => "2018-11-15 11:00:00",
      "ip" => "123456",
      "dispositivo" => "Samsung",
      "acao_realizada" => "teste"
    }
  end

  def user_param() do
    %{
      "email" => "thiagoboeker#{Ecto.UUID.autogenerate()}@gmail.com",
      "fisica_jurid" => "F",
      "cnpj_cpf" => String.slice(Ecto.UUID.autogenerate(), 1..14),
      "sit_app" => "A",
      "nome" => "Victor",
      "ddd" => "027",
      "telefone" => "12-3-45.6",
      "data_nascimento" => "2020-07-07",
      "ramo" => "1",
      "endereco" => "teste",
      "numero" => "teste",
      "bairro" => "teste",
      "cep" => "--teste",
      "cdmunicipio" => "teste",
      "municipio" => "teste",
      "crm_medico" => "teste",
      "cod_cliente" => "nil",
      "loja_cliente" => "12"
    }
  end

  def sync_users() do
    %{
      username: "Victor",
      password: "123456"
    }
  end

  def user() do
    with {:ok, user = %{status_code: 200}} <-
           Firebase.create_user(%{
             email: "victorcliente#{Ecto.UUID.autogenerate()}@gmail.com",
             password: "123456"
           }) do
      Jason.decode!(user.body)
    end
  end

  def put_auth(conn, token) do
    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end

  def users_cliente() do
    %{
      "nome" => "Victor",
      "email" => "victor#{Ecto.UUID.autogenerate()}@gmail.com",
      "cargo" => "Administrativo",
      "status" => 1
    }
  end

  def users_cliente2() do
    %{
      "nome" => "teste",
      "email" => "teste#{Ecto.UUID.autogenerate()}@gmail.com",
      "cargo" => "Administrativo",
      "status" => 1
    }
  end

  def create_user_firebase(email) do
    with {:ok, user = %{status_code: 200}} <-
           Firebase.create_user(%{email: email, password: "123456"}) do
      Jason.decode!(user.body)
    end
  end
end
