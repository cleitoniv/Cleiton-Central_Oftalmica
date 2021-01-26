defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.TestHelp
  use Bamboo.Test
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias TecnovixWeb.Auth.Firebase
  require Phoenix.ChannelTest, as: Channel
  @endpoint TecnovixWeb.Endpoint

  test "user" do
    user_firebase = Generator.user()
    user_client_param = Generator.users_cliente()
    user_param = Generator.user_param()

    # criando o cliente
    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> json_response(201)

    # criando o usuario cliente
    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> recycle()
      |> post("/api/verify_email", %{"email" => user_param["email"]})
      |> json_response(201)
      |> IO.inspect

    # Motrando a Logs
    Tecnovix.Repo.all(Tecnovix.LogsClienteSchema)
  end

  test "cadastro cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    # test de da formatacao do cpf_cnpj
    assert user_param["cnpj_cpf"] == user["cnpj_cpf"]
  end

  test "update" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> put("/api/usuarios_cliente/#{user_client["id"]}", %{
      "param" => %{user_client_param | "status" => 0}
    })
    |> json_response(200)

    {:ok, register} = Tecnovix.UsuariosClienteModel.search_register_email(user_client["email"])

    assert register.email == user_client["email"]
  end

  test "testing email" do
    user = "victorasilva0707@gmail.com"
    senha = String.slice(Tecnovix.Repo.generate_event_id(), 6..12)
    email = Tecnovix.Email.content_email(user, senha, "Victor")

    assert email.to == user
    assert email.subject == "Central Oftalmica - Senha de acesso"

    email = Tecnovix.Email.content_email(user, senha, "Victor")

    email |> Tecnovix.Mailer.deliver_now()

    assert_delivered_email(email)
  end

  test "Alimentando a tebela Atendimento Preferencial" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    user_client_firebase = Generator.create_user_firebase(user_client["email"])

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/atend_pref", %{"horario" => "Tarde"})
    |> recycle()
    |> post("/api/cliente/atend_pref", %{"horario" => "Manha"})
    |> json_response(200)
  end

  test "show cliente/usuario and atendimento preferencial cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    user_client_firebase = Generator.create_user_firebase(user_client["email"])

    # build_conn()
    # |> Generator.put_auth(user_firebase["idToken"])
    # |> post("/api/atend_pref_cliente", %{
    #   "param" => %{"cliente_id" => user["id"], "cod_cliente" => "4321", "seg_tarde" => 1}
    # })
    # |> recycle()
    # |> get("/api/cliente")
    # |> json_response(200)
  end

  test "Pegando os cartões do cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, cartao} = CartaoModel.create(Generator.cartao_cliente(cliente["id"]))

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/cards")
    |> json_response(200)
  end

  test "Inserindo um cartão na conta cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    params_card = Generator.cartao_cliente(cliente["id"])

    card =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{
        "param" => Map.put(params_card, "cartao_number", "5555666677778883")
      })
      |> json_response(200)
      |> Map.get("data")

    card =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => params_card})
      |> json_response(200)
      |> Map.get("data")

    # IO.inspect Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema)

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> delete("/api/cliente/card_delete/#{card["id"]}")
    |> json_response(200)
    |> IO.inspect()

    # IO.inspect(Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema))
  end

  test "Testando o GenServer de pre devolucao" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    products = [
      %{
        num_serie: "011" <> "0989898",
        id: 0,
        tests: 0,
        credits: 0,
        title: "Biosoft Asférica Mensal",
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
        image_url: @product_url,
        type: "miopia",
        boxes: 50,
        quantidade: 10,
        nf: "213_568_596",
        group: "011C"
      },
      %{
        num_serie: "011" <> "0989897",
        id: 0,
        tests: 0,
        credits: 0,
        title: "Biosoft Asférica Mensal",
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
        image_url: @product_url,
        type: "miopia",
        boxes: 50,
        quantidade: 10,
        nf: "213_568_596",
        group: "010C"
      }
    ]

    devolution =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/devolution_continue", %{"products" => products, "tipo" => "T"})
      |> recycle()
      |> post("/api/cliente/devolution_continue", %{"products" => products, "tipo" => "T"})
      |> json_response(200)
      |> Map.get("data")
      |> Map.get("product")

    devolution_params = %{
      num_de_serie: "0110989898",
      paciente: "Mauricio",
      quant: 5,
      numero: "123",
      dt_nas_pac: "07/07/1998",
      esferico: 1.25,
      cilindrico: 1.0,
      eixo: 1.22,
      cor: "Azul",
      adicao: 1.55
    }

    next =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/next_step", %{
        "group" => devolution["group"],
        "quantidade" => 10,
        "devolution" => devolution_params
      })
      |> json_response(200)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/next_step", %{
      "group" => next["group"],
      "quantidade" => 10,
      "devolution" => devolution_params
    })
    |> json_response(200)

    # IO.inspect Tecnovix.Repo.all(Tecnovix.PreDevolucaoSchema)
    # |> Tecnovix.Repo.preload(:items)
  end

  test "Pegando os Graus na DESCRICAO GENERICA DO PRODUTO" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    desc_param = Generator.desc_generica()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, _desc} =
      Tecnovix.DescricaoGenericaDoProdutoModel.create(Map.put(desc_param, "esferico", -2.5))

    for _ <- 1..40000 do
      Tecnovix.DescricaoGenericaDoProdutoModel.create(desc_param)
    end

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/get_graus?grupo=010C")
    |> json_response(200)
    |> IO.inspect()
  end

  test "Testando o socket de open notifications" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    desc_param = Generator.desc_generica()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, socket} =
      Channel.connect(TecnovixWeb.Socket, %{"token" => user_firebase["idToken"]}, %{})

    {:ok, _, socket} = Channel.subscribe_and_join(socket, "cliente:#{cliente["id"]}", %{})
    resp = Channel.push(socket, "update_notifications_number", %{})

    Channel.assert_reply(resp, :ok)

    Channel.assert_broadcast("update_notifications_number", %{})
  end

  test "Testando REST do Via CEP" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    desc_param = Generator.desc_generica()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/get_endereco_by_cep?cep=29027445")
    |> json_response(200)
  end

  test "Acessando com o primeiro acesso e depois cadastrando o complemento" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    user_first_access = %{
      "nome" => "Victor",
      "email" => user_firebase["email"],
      "telefone" => "5527996211804"
    }

    update_first_access = %{
      "nome" => "Caio",
      "email" => user_firebase["email"],
      "telefone" => "77777777"
    }

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    # criando o cliente no primeiro acesso e saindo
    |> post("/api/cliente/first_access", %{"param" => user_first_access})
    |> recycle()
    # entrando para cadastrar denovo com o mesmo email
    |> post("/api/cliente/first_access", %{"param" => update_first_access})
    |> recycle()
    # completando  o cadastro
    |> post("/api/cliente", %{"param" => user_param})
    |> json_response(201)

    IO.inspect(Tecnovix.Repo.all(Tecnovix.ClientesSchema))
  end

  test "Verificando se o email ja foi cadastrado na hora do login" do
    user_firebase = Generator.user()

    user_first_access = %{
      "nome" => "Victor",
      "email" => user_firebase["email"],
      "telefone" => "99999999"
    }

    first_access =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      # criando o cliente no primeiro acesso e saindo
      |> post("/api/cliente/first_access", %{"param" => user_first_access})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> get("/api/verify_field_cadastrado?email=#{first_access["email"]}")
    |> json_response(200)
  end

  test "Criando um TICKET" do
    user_firebase = Generator.user()
    user_client_param = Generator.users_cliente()
    user_param = Generator.user_param()

    # criando o cliente
    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> json_response(201)

    message = %{"message" => "Quero abrir um TICKET"}

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/create_ticket", message)
    |> json_response(200)
    |> IO.inspect
  end
end
