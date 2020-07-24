defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Auth.Firebase
  alias TecnovixWeb.Support.Generator
  alias TecnovixWeb.ClientesController

  test "creating a usuario_cliente" do
    build_conn()
    |> ClientesController.register_users_clientes(Generator.users_cliente())
    |> json_response(200)
  end
end
