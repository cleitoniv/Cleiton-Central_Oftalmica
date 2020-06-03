defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false

  alias TecnovixWeb.Support.Generator

  test "Users - GET PUT POST DELETE" do
    user_param = Generator.user_param()

    user =
      build_conn()
      |> post("/api/user", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    assert user["cnpj_cpf"] == user_param["cnpj_cpf"]

    user =
      build_conn()
      |> put("/api/user/#{user["id"]}", %{"param" => %{user_param | "email" => "thiagoboeker@gmail"}})
      |> json_response(200)
      |> Map.get("data")

    assert user["email"] == "thiagoboeker@gmail"

    user =
      build_conn()
      |> get("/api/user/#{user["id"]}")
      |> json_response(302)
      |> Map.get("data")

    assert user["cnpj_cpf"] == user_param["cnpj_cpf"]

    users =
      build_conn()
      |> get("/api/user?page=1&page_size=20")
      |> json_response(200)
      |> Map.get("data")

    assert length(users) > 0

    user =
      build_conn()
      |> delete("/api/user/#{user["id"]}")
      |> json_response(200)
      |> Map.get("data")

    assert user["cnpj_cpf"] == user_param["cnpj_cpf"]
  end
end
