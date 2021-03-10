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
  "email" => "victorasilva0707@gmail.com",
  "password" => "123456",
  "nome" => "Victor",
  "sit_app" => "A",
  "cnpj_cpf" => "167-939-737-03",
  "regiao" => "Norte ES",
  "celular" => "27 99621 1804",
  "status" => 1
}

Tecnovix.VendedoresModel.create(params)

TecnovixWeb.Auth.FirebaseVendedor.create_user(%{email: params["email"], password: params["password"]})
