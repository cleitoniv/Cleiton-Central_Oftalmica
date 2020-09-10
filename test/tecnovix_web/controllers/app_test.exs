defmodule Tecnovix.Test.App do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Auth.Firebase
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.TestHelp
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.TestHelper
  alias Tecnovix.Resource.Wirecard.Actions
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  describe "Tela de login e tela de cadastro inicial" do
    test "Cadastro efetuado com sucesso" do
      {:ok, user_firebase} =
        Firebase.create_user(%{
          email: "victor#{Ecto.UUID.autogenerate()}@gmail.com",
          password: "123456"
        })

      token = Jason.decode!(user_firebase.body)
      token = token["idToken"]

      resp =
        build_conn()
        |> Generator.put_auth(token)
        |> get("/api/cliente/protheus/#{"03601285720"}")
        |> json_response(200)

      assert resp["status"] == "FOUND"

      param = Generator.user_param()

      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/cliente", %{"param" => param})
      |> json_response(201)
    end

    test "Cadastro não efetuado com sucesso" do
      {:ok, user_firebase} =
        Firebase.create_user(%{
          email: "victor#{Ecto.UUID.autogenerate()}@gmail.com",
          password: "123456"
        })

      token = Jason.decode!(user_firebase.body)
      token = token["idToken"]

      resp =
        build_conn()
        |> Generator.put_auth(token)
        |> get("/api/cliente/protheus/#{"036012857201"}")
        |> json_response(200)

      assert resp["status"] == "NOT_FOUND"
    end
  end

  test "Tela Home" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)
    {:ok, items_json} = TestHelp.items("olhos_diferentes.json")

    Tecnovix.OpcoesCompraCreditoFinanceiroModel.create(%{
      "valor" => 2500,
      "desconto" => 10,
      "prestacoes" => 1
    })

    Tecnovix.OpcoesCompraCreditoFinanceiroModel.create(%{
      "valor" => 5000,
      "desconto" => 10,
      "prestacoes" => 2
    })

    Tecnovix.OpcoesCompraCreditoFinanceiroModel.create(%{
      "valor" => 10000,
      "desconto" => 10,
      "prestacoes" => 3
    })

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

    pedido =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> recycle()
      |> post("/api/cliente/pedidos", %{
        "items" => Enum.map(items, fn map -> Map.put(map, "status_ped", 1) end),
        "id_cartao" => cartao["id"]
      })
      |> recycle()
      |> post("/api/cliente/pedidos", %{"items" => items, "id_cartao" => cartao["id"]})
      |> json_response(200)
      |> Map.get("data")

    current_user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/current_user")
      |> json_response(200)

    assert current_user["money"] == 5500
    assert current_user["points"] == 100
    assert current_user["notifications"]["opens"] == 2

    product =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/produtos?filtro=Miopía")
      |> json_response(200)

    assert product["success"] == true

    offers =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/offers")
      |> json_response(200)

    assert offers["success"] == true

    products_credits =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/products_credits")
      |> json_response(200)

    assert products_credits["success"] == true

    orders =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/orders?filtro=entregues")
      |> json_response(200)

    assert orders["success"] == true

    cart =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/cart")
      |> json_response(200)

    assert cart["success"] == true

    product =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/product/1")
      |> json_response(200)

    assert product["success"] == true

    detail_order =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/detail_order?filtro=0")
      |> json_response(200)

    assert detail_order["success"] == true

    pedido_por_id =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/pedido/#{pedido["id"]}")
      |> json_response(200)
      |> IO.inspect()
  end
end
