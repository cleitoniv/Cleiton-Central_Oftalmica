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
      |> Map.get("data")

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
    refute user_param["cnpj_cpf"] == user["cnpj_cpf"]
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
      "param" => %{user_client_param | "cargo" => "Assistente"}
    })
    |> json_response(200)

    {:ok, register} = Tecnovix.UsuariosClienteModel.search_register_email(user_client["email"])

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> delete("/api/usuarios_cliente/#{user_client["id"]}")
    |> json_response(200)

    assert register.email == user_client["email"]
  end

  test "testing email" do
    user = "victorasilva0707@gmail.com"
    email = Tecnovix.Email.content_email(user)

    assert email.to == user
    assert email.subject == "Central Oftalmica"

    email = Tecnovix.Email.content_email(user)

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

  test "atend pref" do
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
    #   "param" => %{"cliente_id" => user["id"], "cod_cliente" => "1234", "seg_tarde" => 1}
    # })
    # |> recycle()
    # |> post("/api/atend_pref_cliente", %{
    #   "param" => %{"cliente_id" => user["id"], "cod_cliente" => "5678", "seg_tarde" => 1}
    # })
    # |> recycle()
    # |> Generator.put_auth(user_client_firebase["idToken"])
    # |> post("/api/atend_pref_cliente", %{
    #   "param" => %{"cliente_id" => user_client["id"], "cod_cliente" => "1224", "sab_manha" => 1}
    # })
    # |> json_response(201)
    #
    # Tecnovix.Repo.all(Tecnovix.AtendPrefClienteSchema)
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

  test "Criando uma Pre Devoluçao pelo cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    contrato = TestHelp.single_json("single_contrato_de_parceria.json")
    single_param = TestHelp.single_json("single_devolucao_and_items0.json")
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, items} = TestHelp.items("items.json")

    items =
      Enum.map(single_param["items"], fn x ->
        Map.put(x, "descricao_generica_do_produto_id", descricao.id)
      end)

    map = Map.put(single_param, "items", items)

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/pre_devolucao", %{"param" => map})
    |> json_response(200)
    |> IO.inspect()
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
      |> json_response(200)

    # IO.inspect Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema)

    assert card["success"] == true
  end
end
