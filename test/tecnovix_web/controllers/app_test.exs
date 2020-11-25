defmodule Tecnovix.Test.App do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Auth.Firebase
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.TestHelp
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.TestHelper
  alias Tecnovix.Resource.Wirecard.Actions
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel
  use Bamboo.Test

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
        |> get("/api/cliente/protheus/#{"16793973703"}")
        |> json_response(200)

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
    {:ok, items_credito} = TestHelp.items("items_credito.json")

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
      |> post("/api/cliente/pedidos", %{
        "items" => items,
        "id_cartao" => cartao["id"],
        "ccv" => "123",
        "installment" => 1,
        "taxa_entrega" => 100
      })
      |> json_response(200)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/pedido/credito_financeiro", %{
      "items" => items_credito,
      "id_cartao" => cartao["id"]
    })
    |> recycle()
    |> post("/api/cliente/pedido/credito_financeiro", %{
      "items" => items_credito,
      "id_cartao" => cartao["id"]
    })
    |> json_response(200)

    current_user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/current_user")
      |> json_response(200)

    product =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/produtos?filtro=Todos")
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
      |> Map.get("data")

    pedido_por_id =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/pedido/#{pedido["id"]}", %{
        "data_nascimento" => "07/07/1998",
        "reposicao" => true,
        "nome" => "Victor"
      })
      |> json_response(200)

    payments =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/payments?filtro=1")
      |> json_response(200)

    assert payments["success"] == true

    # points =
    #   build_conn()
    #   |> Generator.put_auth(user_firebase["idToken"])
    #   |> get("/api/cliente/points")
    #   |> json_response(200)

    # assert points["success"] == true

    notifications =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/notifications")
      |> json_response(200)

    assert notifications["success"] == true

    read_notifications =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> put("/api/cliente/read_notification/#{249}")
      |> json_response(200)

    # IO.inspect(Tecnovix.Repo.all(Tecnovix.NotificacoesClienteSchema))

    product_serie =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/product_serie/S03006485")
      |> recycle()
      |> get("/api/cliente/product_serie/S03006485")
      |> json_response(200)
      |> IO.inspect()

    extrato_finan =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/extrato_finan")
      |> json_response(200)

    extrato_prod =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/extrato_prod")
      |> json_response(200)
      |> IO.inspect

    email = "victorasilva0707@gmail.com"

    send_email =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/send_email_dev?email=#{email}")
      |> json_response(200)

    paciente = %{
      "paciente" => "Victor",
      "num_pac" => "123123",
      "dt_nas_pac" => "07/07/2020",
      "num_serie" => "123123"
    }

    points =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/add_points", %{"param" => paciente})
      |> json_response(200)

    convert_points =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/convert_points?points=100")
      |> json_response(200)

    rescue_points =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/rescue_points", %{"points" => 100, "credit_finan" => 104})
      |> json_response(200)

    endereco_entrega =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> get("/api/cliente/endereco_entrega")
      |> json_response(200)
  end

  test "email" do
    user = "victorasilva0707@gmail.com"
    email = Tecnovix.Email.content_email_dev(user)

    assert email.to == user

    email = Tecnovix.Email.content_email_dev(user)

    email |> Tecnovix.Mailer.deliver_now()

    assert_delivered_email(email)
  end

  test "Generate Boleto" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    params = TestHelp.single_json("single_descricao_generica_do_produto.json")
    {:ok, descricao} = DescricaoModel.create(params)
    {:ok, items_json} = TestHelp.items("items.json")

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/generate_boleto?valor=15100")
    |> json_response(200)
  end

  test "Envio de SMS" do
    phone_number = "5527996211804"

    codigo =
      build_conn()
      |> get("/api/send_sms", %{"phone_number" => phone_number})
      |> json_response(200)
      |> Map.get("data")

    build_conn()
    |> get("/api/confirmation_code", %{"code_sms" => codigo, "phone_number" => phone_number})
    |> json_response(200)
  end

  test 'test' do
    Tecnovix.ClientesModel.confirmation_code(1234, 5_527_996_211_804)
  end
end
