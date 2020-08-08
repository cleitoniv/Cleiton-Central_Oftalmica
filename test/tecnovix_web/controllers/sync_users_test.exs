defmodule Tecnovix.SyncUsers do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.Endpoints.ProtheusProd

  test "Create Sync User" do
    Generator.sync_user("thiagoboeker", "123456")

    _login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)
  end

  test "token" do
    Generator.sync_user("thiagoboeker", "123456")

    # testing auth token
    user_login =
      build_conn()
      |> post("/api/user_sync/login", %{"username" => "thiagoboeker", "password" => "123456"})
      |> json_response(200)

    # testing auth refresh_token
    _refresh_login =
      build_conn()
      |> post("/api/user_sync/login", %{"refresh_token" => user_login["refresh_token"]})
      |> json_response(200)
  end

  test "testing invalid credencials" do
    # gerando um usuario válido
    Generator.sync_user("thiagoboeker", "123456")

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

  test "Central Endpoint Prod" do
    ProtheusProd.new_token(%{"username" => "TECNOVIX", "password" => "TecnoVix200505"})
  end
end
