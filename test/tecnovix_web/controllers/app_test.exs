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
end
