defmodule Tecnovix.Test.Wirecard do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Auth.Firebase
  alias Tecnovix.TestHelper
  alias Tecnovix.Resource.Wirecard.Actions

  test "Criando a order do wirecard com o cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, items} = TestHelp.items("items.json")
    {:ok, cartao} = CartaoModel.create(Generator.cartao_cliente(cliente["id"]))

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/create_order", %{"items" => items})
    |> json_response(200)
    |> IO.inspect()
  end

  test "Criando a order do wirecard com o Usuario Cliente" do
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

    {:ok, items} = TestHelp.items("items.json")
    cartao_cliente = Generator.cartao_cliente(cliente["id"])
    {:ok, cartao} = CartaoModel.create(cartao_cliente)

    {:ok, usuarioAuth} = Firebase.sign_in(%{email: user_client["email"], password: "123456"})
    usuarioAuth = Jason.decode!(usuarioAuth.body)

    build_conn()
    |> Generator.put_auth(usuarioAuth["idToken"])
    |> post("/api/cliente/create_order", %{"items" => items})
    |> json_response(200)
    |> IO.inspect()
  end

  test "Criando o Payment do wirecard com o o cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, items} = TestHelp.items("items.json")

    order =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/create_order", %{"items" => items})
      |> json_response(200)
      |> Map.get("data")
    {:ok, cartao} = CartaoModel.create(Generator.cartao_cliente(cliente["id"]))

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente/create_payment", %{
      "cartao" => cartao.id,
      "order_id" => order["id"]
    })
    |> json_response(200)
  end
end
