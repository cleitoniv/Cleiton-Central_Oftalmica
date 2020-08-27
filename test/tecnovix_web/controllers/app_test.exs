defmodule Tecnovix.Test.App do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Auth.Firebase
  alias TecnovixWeb.Support.Generator

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

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> json_response(201)
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
      |> get("/api/cliente/product?id=1")
      |> json_response(200)
      |> IO.inspect

    assert product["success"] == true
  end
end
