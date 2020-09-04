defmodule Tecnovix.Test.Wirecard do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Auth.Firebase
  alias Tecnovix.TestHelper
  alias Tecnovix.Resource.Wirecard.Actions
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  test "Fazendo um pedido e inserindo o pedido no banco do pedido de produtos // CLIENTE" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
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
          Map.put(map, "items", items)
        end
      )

    data =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)
      |> IO.inspect

    assert data["success"] == true
  end

  test "Fazendo um pedido e inserindo o pedido no banco do pedido de produtos // USUARIO_CLIENTE" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()
    paciente = %{"paciente" => "Victor"}
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)

    cliente =
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

    {:ok, items} = TestHelp.items("items.json")
    {:ok, usuarioAuth} = Firebase.sign_in(%{email: user_client["email"], password: "123456"})
    usuarioAuth = Jason.decode!(usuarioAuth.body)
    cartao = Generator.cartao_cliente(cliente["id"])

    cartao =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => cartao})
      |> json_response(200)
      |> Map.get("data")

    items =
      Enum.map(items, fn x -> Map.put(x, "descricao_generica_do_produto_id", descricao.id) end)

    data =
      build_conn()
      |> Generator.put_auth(usuarioAuth["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)
      |> IO.inspect

    assert data["success"] == true
  end

  test "Criando Pedido e Pagamento do pedido do Credito Financeiro // CLIENTE" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, items} = TestHelp.items("items_credito.json")
    cartao = Generator.cartao_cliente(cliente["id"])

    cartao =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => cartao})
      |> json_response(200)
      |> Map.get("data")

    data =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedido/credito_financeiro", %{
        "items" => items,
        "id_cartao" => cartao["id"]
      })
      |> json_response(200)

    assert data["success"] == true
  end

  test "Criando Pedido e Pagamento do pedido do Credito Financeiro // USUARIO_CLIENTE" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    cliente =
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

    {:ok, items} = TestHelp.items("items_credito.json")
    {:ok, usuarioAuth} = Firebase.sign_in(%{email: user_client["email"], password: "123456"})
    usuarioAuth = Jason.decode!(usuarioAuth.body)
    cartao = Generator.cartao_cliente(cliente["id"])

    cartao =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => cartao})
      |> json_response(200)
      |> Map.get("data")

    data =
      build_conn()
      |> Generator.put_auth(usuarioAuth["idToken"])
      |> post("/api/cliente/pedido/credito_financeiro", %{
        "param" => items,
        "id_cartao" => cartao["id"]
      })
      |> json_response(200)

    assert data["success"] == true
  end

  test "Criando um pedido com Grau de Olhos Diferentes" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, items_json} = TestHelp.items("olhos_diferentes.json")
    cartao = Generator.cartao_cliente(cliente["id"])

    cartao =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => cartao})
      |> json_response(200)
      |> Map.get("data")

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
          Map.put(map, "items", items)
        end
      )

    data =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)

    assert data["success"] == true
  end

  test "Comprando produto no Contrato de Parceria" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
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

    {:ok, items} = TestHelp.items("items_contrato.json")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/contrato_parceria", %{"items" => items, "id_cartao" => cartao["id"]})
    |> json_response(200)
  end
end
