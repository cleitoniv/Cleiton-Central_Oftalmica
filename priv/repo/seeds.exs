# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tecnovix.Repo.insert!(%Tecnovix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Tecnovix.SyncUsersModel.create(%{
  "username" => "centralof_api",
  "password" => "centralof_api08082020"
})

params = %{
  "email" => "teste@centraloftalmica.com",
  "password" => "123456",
  "nome" => "Teste",
  "sit_app" => "A",
  "cnpj_cpf" => "000-000-000-00",
  "regiao" => "Norte ES",
  "telefone" => "27 00000 0000",
  "status" => 1
}

Tecnovix.VendedoresModel.create(params)

TecnovixWeb.Auth.FirebaseVendedor.create_user(%{
  email: params["email"],
  password: params["password"]
})
