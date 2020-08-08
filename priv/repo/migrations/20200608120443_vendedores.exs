defmodule Tecnovix.Repo.Migrations.Vendedores do
  use Ecto.Migration

  def change do
    create table(:vendedores) do
      add :uid, :string, size: 255
      add :codigo, :string, size: 6
      add :nome, :string, size: 40
      add :sit_app, :string, size: 1
      add :cnpj_cpf, :string, size: 14
      add :email, :string, size: 80
      add :regiao, :string, size: 3
      add :celular, :string, size: 15
      add :status, :string, size: 1
      add :moip_account_id, :string, size: 255
      add :moip_acess_token, :string, size: 255

      timestamps()
    end

    create unique_index(:vendedores, :uid)
    create unique_index(:vendedores, :codigo)
    create unique_index(:vendedores, :cnpj_cpf)
  end
end
