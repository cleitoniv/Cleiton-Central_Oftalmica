defmodule Tecnovix.Test.VendedorTest do
  use TecnovixWeb.ConnCase, async: false
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Support.Generator

  test "Get a current seller" do
    # {:ok, resp} = TecnovixWeb.Auth.FirebaseVendedor.sign_in(%{email: "victorasilva0707@gmail.com", password: "123123"})

    # {:ok, seller} = Jason.decode(resp.body)

    # build_conn
    # |> Generator.put_auth(seller["idToken"])
    # |> get("/api/vendedor/current_seller")
    # |> json_response(200)
    # |> IO.inspect
  end
end
