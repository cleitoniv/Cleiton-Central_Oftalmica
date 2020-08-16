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

  def cartao_cliente() do
    %{
      "cliente_id" => "1",
      "nome_titular" => "Victor",
      "cpf_titular" => "8888888888",
      "telefone_titular" => "996211804",
      "data_nascimento_titular" => "2020-08-14",
      "primeiros_6_digitos" => "123456",
      "ultimos_4_digitos" => "1234",
      "mes_validade" => 08,
      "ano_validade" => 2020,
      "bandeira" => "M",
      "status" => 1,
      "wirecard_cartao_credito_hash" => "1212121",
      "cep_endereco_cobranca" => ":string",
      "logradouro_endereco_cobranca" => ":string",
      "numero_endereco_cobranca" => "",
      "complemento_endereco_cobranca" => "",
      "bairro_enderco_cobranca" => "",
      "cidade_endereco_cobranca" => "",
      "festado_endereco_cobranca" => ""
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

  def wirecard_cliente_param() do
    %{
      "uid" => Ecto.UUID.autogenerate(),
      "birthDate" => "2020-08-14",
      "type" => "CPF",
      "number" => "22288866644",
      "phone" => "27996211804",
      "city" => "São Paulo",
      "complement" => "10",
      "district" => "Itaim Bibi",
      "street" => "Avenida Faria Lima",
      "streetNumber" => "500",
      "zipCode" => "01234000",
      "state" => "SP",
      "country" => "BRA",
      "email" => "victor@gmail.com",
      "name" => "Victor Silva",
      "ownId" => "1",
      "fixed" => 2100,
      "complement" => "Teste"
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
      "status" => 1,
      "password" => "123456"
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
