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

  def desc_generica() do
    %{
      "grupo" => "010C",
      "codigo" => "005678",
      "descricao" => "Testando",
      "esferico" => 1.25,
      "cilindrico" => 1.50,
      "eixo" => 1,
      "cor" => "Azul",
      "diametro" => 1.0,
      "curva_base" => 1.5,
      "adic_padrao" => "1",
      "adicao" => 1,
      "raio_curva" => "1.5",
      "link_am_app" => "http",
      "blo_de_tela" => "1"
    }
  end

  def user_param() do
    %{
      "email" => "thiagoboeker#{Ecto.UUID.autogenerate()}@gmail.com",
      "fisica_jurid" => "F",
      "cnpj_cpf" => String.slice(Float.to_string(:rand.uniform()), 2..12),
      "sit_app" => "A",
      "nome" => "Victor",
      "ddd" => "27",
      "telefone" => "33225111",
      "data_nascimento" => "07/07/1998",
      "ramo" => "1",
      "endereco" => "Rua Benedito Barcelos",
      "numero" => "111",
      "bairro" => "Bela Vista",
      "estado" => "Vitoria",
      "cep" => "29027445",
      "cdmunicipio" => "teste",
      "municipio" => "Serra",
      "crm_medico" => "teste",
      "cod_cliente" => "nil",
      "dia_remessa" => "3",
      "loja_cliente" => "01",
      "codigo" => String.slice(Ecto.UUID.autogenerate(), 0..4),
      "complemento" => "Casa"
    }
  end

  def user_param_N() do
    %{
      "email" => "thiagoboeker#{Ecto.UUID.autogenerate()}@gmail.com",
      "fisica_jurid" => "F",
      "cnpj_cpf" => String.slice(Ecto.UUID.autogenerate(), 1..12),
      "sit_app" => "N",
      "nome" => "Victor",
      "ddd" => "27",
      "telefone" => "5527996211804",
      "data_nascimento" => "2020-07-07",
      "ramo" => "1",
      "endereco" => "Rua Benedito Barcelos",
      "numero" => "111",
      "bairro" => "Bela Vista",
      "cep" => "29027445",
      "cdmunicipio" => "teste",
      "municipio" => "Serra",
      "crm_medico" => "teste",
      "cod_cliente" => "nil",
      "loja_cliente" => "12",
      "codigo" => String.slice(Ecto.UUID.autogenerate(), 0..4),
      "complemento" => "Casa"
    }
  end

  def cartao_cliente(cliente_id) do
    %{
      "cliente_id" => cliente_id,
      "nome_titular" => "Tecnovix",
      "cpf_titular" => "78994193600",
      "telefone_titular" => "5527996211804",
      "data_nascimento_titular" => "2020-08-08",
      "primeiros_6_digitos" => "123456",
      "ultimos_4_digitos" => "1234",
      "mes_validade" => "06",
      "ano_validade" => "2022",
      "cartao_number" => "5555666677778884",
      "bandeira" => "Mastercard",
      "wirecard_cartao_credito_id" => "12",
      "wirecard_cartao_credito_hash" => "1232131231",
      "cep_endereco_cobranca" => "29027445",
      "logradouro_endereco_cobranca" => "Rua Helena",
      "numero_endereco_cobranca" => "550",
      "complemento_endereco_cobranca" => "casa",
      "bairro_endereco_cobranca" => "Enseada do sua",
      "cidade_endereco_cobranca" => "Belo Horizonte",
      "estado_endereco_cobranca" => "ES"
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
      "email" => "victorsdsdasad#{Ecto.UUID.autogenerate()}@gmail.com",
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
