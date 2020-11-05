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

    pedido =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{
        "items" => items,
        "id_cartao" => cartao["id"],
        "ccv" => "123",
        "installment" => 2
      })
      |> json_response(200)
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

    {:ok, usuarioAuth} =
      Firebase.sign_in(%{email: user_client["email"], password: user_client["password"]})

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

    {:ok, usuarioAuth} =
      Firebase.sign_in(%{email: user_client["email"], password: user_client["password"]})

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
        "items" => items,
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

    {:ok, items_json} = TestHelp.items("items_contrato.json")

    items =
      Enum.map(
        items_json["items"],
        fn item ->
          Map.put(item, "descricao_generica_do_produto_id", descricao.id)
        end
      )

    items = Map.put(items_json, "items", items)

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/contrato_de_parceria", %{
      "items" => items,
      "id_cartao" => cartao["id"]
    })
    |> json_response(200)
  end

  test "Testando o processo da verificação do pedido" do
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

    cartao2 =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => Map.put(cartao, "cartao_number", "4444444444")})
      |> json_response(200)

    IO.inspect(Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema))

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> put("/api/cliente/select_card/#{cartao["id"]}")
    |> json_response(200)
    |> IO.inspect()

    IO.inspect(Tecnovix.Repo.all(Tecnovix.CartaoCreditoClienteSchema))

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
      |> recycle()
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)

    start_supervised!(Tecnovix.Services.Order)
    # IO.inspect(Tecnovix.Services.Order.get_msg())
  end

  test "Graus bloqueados" do
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

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/verify_graus", %{"axis" => 2.76})
    |> json_response(200)
    |> IO.inspect()
  end

  test "Cancelamento de pedido pela wirecard" do
    user_firebase = Generator.user()
    user_reject = Generator.user_reject()
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_reject})
      |> json_response(201)
      |> Map.get("data")

    cartao = Generator.cartao_reject(cliente["id"])

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

    pedido =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)
  end

  test "Fazendo um pedido e pagando por boleto" do
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

    pedido =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedido_boleto", %{"items" => items, "parcela" => 1})
      |> json_response(200)
      |> IO.inspect()
  end

  test "Valor em cima das taxas" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/taxa?valor=#{15100}")
    |> json_response(200)
    |> IO.inspect()
  end
end
