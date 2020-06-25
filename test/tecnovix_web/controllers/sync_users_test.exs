defmodule Tecnovix.SyncUsers do
  use TecnovixWeb.ConnCase, async: false
  alias Tecnovix.Support.Generator

  test "Create Sync User" do
    user_param = Generator.sync_users()

    user =
    build_conn()
    |> post("/api/user", %{"param" => user_param})
    |> json_response(201)
    |> Map.get("data")
    assert user["username"] == user_param.username

    login =
      build_conn()
      |> post("/api/login", %{"username" => user["username"], "password" => "123456"})
      |> json_response(200)
  end

  test "token" do
    user_param = Generator.sync_users() #gerando um usuario válido

    user =
    build_conn()
    |> post("/api/user", %{"param" => user_param})
    |> json_response(201)
    |> Map.get("data")
    assert user["username"] == user_param.username

    # testing auth token
    user_login =
      build_conn()
      |> post("/api/login", %{"username" => user["username"], "password" => "123456"})
      |> json_response(200)

    user =
      build_conn()
      |> put_req_header("authorization", "Bearer " <> user_login["acess_token"])
      |> post("/api/teste", %{"param" => "e"})
      |> json_response(200 )

      assert user["message"] == "ok"
    #testing auth refresh_token
    refresh_login =
      build_conn()
      |> post("/api/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(200)

    user =
      build_conn()
      |> put_req_header("authorization", "Bearer " <> user_login["acess_token"])
      |> post("/api/teste", %{"param" => "e"})
      |> json_response(200)

      assert user["message"] == "ok"
  end

  test "testing invalid credencials" do
    user_param = Generator.sync_users() #gerando um usuario válido

    user =
    build_conn()
    |> post("/api/user", %{"param" => user_param})
    |> json_response(201)
    |> Map.get("data")

    assert user["username"] == user_param.username

    # testing false username
    user_login =
      build_conn()
      |> post("/api/login", %{"username" => "Gabriel", "password" => "123456"}) #"Gabriel" is username invalid
      |> json_response(401)

      assert user["message"] == "Credenciais ou token inválido"
    #testing false username with refresh_token
    refresh_login =
      build_conn()
      |> post("/api/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(401)

      assert refresh_login["message"] == "Credenciais ou token inválido"
  end
end
