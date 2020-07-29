defmodule Tecnovix.SyncUsers do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator

  test "Create Sync User" do
    user_param = Generator.sync_users()

    user =
      build_conn()
      |> post("/api/user_sync", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    assert user["username"] == user_param.username

    _login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => user["username"], "password" => "123456"})
      |> json_response(200)
  end

  test "token" do
    # gerando um usuario válido
    user_param = Generator.sync_users()

    user =
      build_conn()
      |> post("/api/user_sync", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    assert user["username"] == user_param.username

    # testing auth token
    user_login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => user["username"], "password" => "123456"})
      |> json_response(200)

    # testing auth refresh_token
    _refresh_login =
      build_conn()
      |> post("/api/user_sync/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(200)
  end

  test "testing invalid credencials" do
    # gerando um usuario válido
    user_param = Generator.sync_users()

    user =
      build_conn()
      |> post("/api/user_sync", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    assert user["username"] == user_param.username

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
end
