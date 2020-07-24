defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  use Bamboo.Test

  test "user" do
    user_firebase = Generator.user()
    user_client_param = Generator.users_cliente()
    user_param = Generator.user_param()

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> IO.inspect()
    |> json_response(201)

    user_client =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
      |> json_response(201)
      |> Map.get("data")

    Tecnovix.Repo.all(Tecnovix.LogsClienteSchema)

    user_client_firebase = Generator.create_user_firebase(user_client["email"])

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> get("/api/cliente/message")
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(user_client_firebase["idToken"])
    |> get("/api/cliente/message")
    |> json_response(200)
  end

  test "cadastro cliente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    user =
      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/cliente", %{"param" => user_param})
      |> json_response(201)
      |> Map.get("data")

    # test de da formatacao do cpf_cnpj
    refute user_param["cnpj_cpf"] == user["cnpj_cpf"]
  end

  test "logs cliente" do
    logs_param = Generator.logs_param()
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> recycle()
    |> post("/api/cliente/logs", %{"param" => logs_param})
    |> json_response(200)
  end

  test "cadastro existente" do
    user_firebase = Generator.user()
    user_param = Generator.user_param()

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> post("/api/cliente", %{"param" => user_param})
    |> recycle()
    |> post("/api/cliente", %{"param" => user_param})
    |> json_response(201)
    |> Map.get("data")
  end

  test "update" do
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
    |> put("/api/usuarios_cliente/#{user_client["id"]}", %{
      "param" => %{user_client_param | "cargo" => "Assistente"}
    })
    |> json_response(200)

    {:ok, register} = Tecnovix.UsuariosClienteModel.search_register_email(user_client["email"])

    build_conn()
    |> Generator.put_auth(user_firebase["idToken"])
    |> delete("/api/usuarios_cliente/#{user_client["id"]}")
    |> json_response(200)

    assert register.email == user_client["email"]
    assert user_client["cliente_id"] == user["id"]
  end

  test "testing email" do
    user = "victorasilva0707@gmail.com"
    email = Tecnovix.Email.content_email(user)

    assert email.to == user
    assert email.subject == "Central Oftalmica"

    email = Tecnovix.Email.content_email(user)

    email |> Tecnovix.Mailer.deliver_now()

    assert_delivered_email(email)
  end

  test "show all users" do
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
      |> get("/api/usuarios_cliente")
      |> json_response(200)
  end

  test "atend pref" do
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

      user_client_firebase = Generator.create_user_firebase(user_client["email"])

      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/atend_pref_cliente", %{"param" => %{"cliente_id" => user["id"], "cod_cliente" => "1234", "seg_tarde" => 1}})
      |> recycle()
      |> post("/api/atend_pref_cliente", %{"param" => %{"cliente_id" => user["id"], "cod_cliente" => "1234", "seg_tarde" => 1}})
      |> recycle()
      |> Generator.put_auth(user_client_firebase["idToken"])
      |> post("/api/atend_pref_cliente", %{"param" => %{"cliente_id" => user_client["id"], "cod_cliente" => "1224", "sab_manha" => 1}})
      |> json_response(201)

      Tecnovix.Repo.all(Tecnovix.AtendPrefClienteSchema)
  end

  test "show cliente/usuario and atendimento preferencial cliente" do
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

      user_client_firebase = Generator.create_user_firebase(user_client["email"])

      build_conn()
      |> Generator.put_auth(user_firebase["idToken"])
      |> post("/api/atend_pref_cliente", %{"param" => %{"cliente_id" => user["id"], "cod_cliente" => "1234", "seg_tarde" => 1}})
      |> recycle()
      |> get("/api/cliente")
      |> json_response(200)
      |> IO.inspect
  end
end
