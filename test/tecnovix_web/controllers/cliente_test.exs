defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.TestHelp
  use Bamboo.Test
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias TecnovixWeb.Auth.Firebase

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
      |> json_response(201)

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
    |> IO.inspect

    {:ok, register} = Tecnovix.UsuariosClienteModel.search_register_email(user_client["email"])

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> delete("/api/usuarios_cliente/#{user_client["id"]}")
    |> json_response(200)

    assert register.email == user_client["email"]
  end

  test "testing email" do
    user = "victorasilva0707@gmail.com"
    senha = Tecnovix.Repo.generate_event_id()
    email = Tecnovix.Email.content_email(user, senha)

    assert email.to == user
    assert email.subject == "Central Oftalmica"

    email = Tecnovix.Email.content_email(user, senha)

    email |> Tecnovix.Mailer.deliver_now()

    assert_delivered_email(email)
  end

  test "show all users" do
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
    |> get("/api/usuarios_cliente?page=1&page_size=20")
    |> json_response(200)
    |> IO.inspect()
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
    |> post("/api/cliente/atend_pref", %{"horario" => "tarde"})
    |> recycle()
    |> post("/api/cliente/atend_pref", %{"horario" => "manha"})
    |> json_response(200)
    |> IO.inspect()
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

  test "Pegando os cartões do cliente com o USUARIO CLIENTE" do
    user_client_param = Generator.users_cliente()
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, cartao} = CartaoModel.create(Generator.cartao_cliente(cliente["id"]))
    {:ok, cartao} = CartaoModel.create(Generator.cartao_cliente(cliente["id"]))

    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, usuarioAuth} = Firebase.sign_in(%{email: user_client["email"], password: "123456"})
    usuarioAuth = Jason.decode!(usuarioAuth.body)

    build_conn()
    |> Generator.put_auth(usuarioAuth["idToken"])
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
      |> post("/api/cliente/card", %{"param" => params_card})
      |> recycle()
      |> post("/api/cliente/card", %{"param" => params_card})
      |> recycle()
      |> post("/api/cliente/card", %{"param" => params_card})
      |> recycle()
      |> post("/api/cliente/card", %{"param" => params_card})
      |> json_response(200)

    # IO.inspect Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema)

    assert card["success"] == true
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
        group: "010C"
      }
    ]

    devolution =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/devolution_continue", %{"products" => products, "tipo" => "T"})
      |> json_response(200)
      |> Map.get("data")
      |> Map.get("product")

    devolution_params = %{
      num_de_serie: "0110989898",
      paciente: "Mauricio",
      quant: 5,
      numero: "123",
      dt_nas_pac: "2020/07/07",
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

  test "Atualizando a senha do usuario cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    update =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/update_password", %{
        "idToken" => user_firebase["idToken"],
        "new_password" => "111111"
      })
      |> json_response(200)
      |> IO.inspect()
  end
end
