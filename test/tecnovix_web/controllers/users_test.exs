defmodule TecnovixWeb.UsersTest do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Auth.Firebase
  alias TecnovixWeb.Support.Generator

 test "user" do
   user_firebase = Generator.user()
   user_client_param = Generator.users_cliente()
   user_param = Generator.user_param()

   user =
     build_conn()
     |> Generator.put_auth(user_firebase["idToken"])
     |> post("/api/cliente", %{"param" => user_param})
     |> json_response(201)

   user_client =
     build_conn()
     |> Generator.put_auth(user_firebase["idToken"])
     |> post("/api/cliente/cliente_user", %{"param" => user_client_param})
     |> json_response(201)
     |> Map.get("data")

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

     refute user_param["cnpj_cpf"] == user["cnpj_cpf"] #test de da formatacao do cpf_cnpj
 end

 test "logs cliente" do
   logs_param = Generator.logs_param()
   user_firebase = Generator.user()
   user_param = Generator.user_param()
   user_client_param = Generator.users_cliente()

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

   user =
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

   user_client_update =
     build_conn()
     |> Generator.put_auth(user_firebase["idToken"])
     |> put("/api/usuarios_cliente/#{user_client["id"]}", %{"param" => %{user_client_param | "cargo" => "Assistente"}})
     |> json_response(200)
     |> Map.get("data")

    {:ok, register} = Tecnovix.UsuariosClienteModel.search_register_email(user_client["email"])

    assert register.email == user_client["email"]
    assert user_client["cliente_id"] == user["id"]
 end
end
