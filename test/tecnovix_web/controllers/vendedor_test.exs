defmodule Tecnovix.Test.VendedorTest do
  use TecnovixWeb.ConnCase, async: false
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Support.Generator

  setup do
    params = %{
      "email" => "victorasilva0707@gmail.com",
      "password" => "123456",
      "nome" => "Victor",
      "sit_app" => "A",
      "cnpj_cpf" => "167-939-737-03",
      "regiao" => "Norte ES",
      "telefone" => "27 99621 1804",
      "status" => 1,
      "data_nascimento" => "07/07/07",
      "codigo" => "033"
    }

    Tecnovix.VendedoresModel.create(params)

    :ok
  end

  test "Get a current seller" do
    {:ok, resp} =
      TecnovixWeb.Auth.FirebaseVendedor.sign_in(%{
        email: "victorasilva0707@gmail.com",
        password: "123123"
      })

    {:ok, seller} = Jason.decode(resp.body)

    build_conn
    |> Generator.put_auth(seller["idToken"])
    |> get("/api/vendedor/current_seller")
    |> json_response(200)
    |> IO.inspect()
  end

  test "Get all clients of seller" do
    {:ok, resp} =
      TecnovixWeb.Auth.FirebaseVendedor.sign_in(%{
        email: "victorasilva0707@gmail.com",
        password: "123456"
      })

    {:ok, seller} = Jason.decode(resp.body)

    build_conn()
    |> Generator.put_auth(seller["idToken"])
    |> get("/api/vendedor/my_clients")
    |> json_response(200)
    |> IO.inspect()
  end

  test "CRUD of the schedule" do
    user_firebase = Generator.user()
    user_client_param = Generator.users_cliente()
    user_param = Generator.user_param()

    # criando o cliente
    cliente =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    {:ok, resp} =
      TecnovixWeb.Auth.FirebaseVendedor.sign_in(%{
        email: "victorasilva0707@gmail.com",
        password: "123456"
      })

    {:ok, seller} = Jason.decode(resp.body)

    seller_database =
      Tecnovix.Repo.get_by(Tecnovix.VendedoresSchema, email: "victorasilva0707@gmail.com")

    params = %{
      "vendedor_id" => seller_database.id,
      "temporizador" => "2131231231",
      "date" => "02/02/2020",
      "turno_manha" => true,
      "cliente_id" => cliente["id"]
    }

    agenda =
      build_conn()
      |> Generator.put_auth(seller["idToken"])
      |> post("/api/vendedor/agenda/create", %{"param" => params})
      |> json_response(201)
      |> Map.get("data")

    build_conn()
    |> Generator.put_auth(seller["idToken"])
    |> get("/api/vendedor/agenda/get_schedules")
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(seller["idToken"])
    |> get("/api/vendedor/agenda/get_schedule")
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(seller["idToken"])
    |> get("/api/vendedor/agenda/get_citys")
    |> json_response(200)
  end
end
