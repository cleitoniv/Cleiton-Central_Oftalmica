defmodule Tecnovix.SyncUsers do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.Endpoints.ProtheusProd
  alias Tecnovix.TestHelp
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  test "Create Sync User" do
    Generator.sync_user("thiagoboeker", "123456")

    _login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)
  end

  test "token" do
    Generator.sync_user("thiagoboeker", "123456")

    # testing auth token
    user_login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)

    # testing auth refresh_token
    _refresh_login =
      build_conn()
      |> post("/api/user_sync/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(200)
  end

  test "testing invalid credencials" do
    # gerando um usuario válido
    Generator.sync_user("thiagoboeker", "123456")

    # testing false username
    user_login =
      build_conn()
      # "Gabriel" is username invalid
      |> post("/api/user_sync/login", %{"username" => "Gabriel", "password" => "123456"})
      |> json_response(401)

    assert user_login["message"] == "Credenciais ou token inválido"
    # testing false username with refresh_token
    refresh_login =
      build_conn()
      |> post("/api/user_sync/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(401)

    assert refresh_login["message"] == "Credenciais ou token inválido"
  end

  test "Central Endpoint Prod" do
    {:ok, resp} = ProtheusProd.token(%{username: "TECNOVIX", password: "TecnoVix200505"})
    body = Jason.decode!(resp.body)
    {:ok, resp} = ProtheusProd.refresh_token(%{refresh_token: body["refresh_token"]})
    body = Jason.decode!(resp.body)

    {:ok, cliente} =
      ProtheusProd.get_cliente(%{cnpj_cpf: "03601285720", token: body["access_token"]})

    IO.inspect(cliente)
  end

  test "O Protheus pegar os clientes do APP" do
    Generator.sync_user("thiagoboeker", "123456")
    user_param = Generator.user_param()
    user_param_N = Generator.user_param_N()
    user_firebase = Generator.user()

    # criando o cliente
    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> recycle()
    |> post("/api/cliente", %{"param" => user_param_N})
    |> json_response(201)

    user_login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)

    build_conn()
    |> Generator.put_auth(user_login["access_token"])
    |> get("/api/sync/clientes?filtro=N")
    |> json_response(200)
  end

  test "O Protheus pegar os pedidos do APP" do
    Generator.sync_user("thiagoboeker", "123456")
    user_param = Generator.user_param()
    user_param_N = Generator.user_param_N()
    user_firebase = Generator.user()
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    cartao = Generator.cartao_cliente(cliente["id"])

    cartao =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => cartao})
      |> json_response(200)
      |> Map.get("data")

    {:ok, items_json} = TestHelp.items("items.json")

    items =
      Enum.flat_map(
        items_json,
        fn map ->
          Enum.map(
            map["items"],
            fn items ->
              Map.put(items, "descricao_generica_do_produto_id", descricao.id)
            end
          )
        end
      )

    items =
      Enum.map(
        items_json,
        fn map ->
          case map["type"] do
            "A" ->
              item =
                Enum.filter(items, fn item ->
                  item["codigo"] == "123132213123"
                end)

              Map.put(map, "items", item)

            "C" ->
              item =
                Enum.filter(items, fn item ->
                  item["codigo"] == "12313131"
                end)

              Map.put(map, "items", item)
          end
        end
      )

    data =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)

    # # criando o cliente
    # build_conn()
    # |> Generator.put_auth(user_firebase["idToken"])
    # |> post("/api/cliente", %{"param" => user_param})
    # |> recycle()
    # |> post("/api/cliente", %{"param" => user_param_N})
    # |> json_response(201)

    user_login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)

    pedidos =
      build_conn()
      |> Generator.put_auth(user_login["access_token"])
      |> get("/api/sync/pedidos?filtro=0")
      |> json_response(200)
      |> IO.inspect()
  end
end
