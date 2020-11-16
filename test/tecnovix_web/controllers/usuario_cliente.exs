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
  end

  test "Pegando os cartões do cliente com o USUARIO CLIENTE" do
    user_client_param = Generator.users_cliente()
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    card = %{
      "cartao_number" => "5555666677778884",
      "nome_titular" => "Victor Teste",
      "mes_validade" => "12",
      "ano_validade" => "2022"
    }

    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    card =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/card", %{"param" => card})
      |> json_response(200)

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

  test "Mostrando todos usuarios cliente" do
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
  end

  test "Deletando um usuario cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    usuario_cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, usuarioAuth} =
      Firebase.sign_in(%{email: usuario_cliente["email"], password: usuario_cliente["password"]})

    usuarioAuth = Jason.decode!(usuarioAuth.body)

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> delete("/api/usuarios_cliente/#{usuario_cliente["id"]}", %{
      "idToken" => usuarioAuth["idToken"]
    })
    |> json_response(200)
  end

  test "Deletando um usuario cliente com o usuario cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()
    user_client_param = Generator.users_cliente()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    usuario_cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, usuarioAuth} =
      Firebase.sign_in(%{email: usuario_cliente["email"], password: usuario_cliente["password"]})

    usuarioAuth = Jason.decode!(usuarioAuth.body)

    build_conn()
    |> Generator.put_auth(usuarioAuth["idToken"])
    |> delete("/api/usuarios_cliente/#{usuario_cliente["id"]}", %{
      "idToken" => usuarioAuth["idToken"]
    })
    |> json_response(200)
  end
end
