defmodule Tecnovix.Repo.Migrations.AlterVendedor do
  use Ecto.Migration

  def change do
    alter table(:vendedores) do
      remove :status
      add :status, :integer
      remove :moip_account_id
      remove :moip_acess_token
      remove :celular
      add :ddd, :string
      add :telefone, :string
      remove :regiao
      add :regiao, :string
      remove :codigo
      add :codigo, :string
      remove :nome
      add :nome, :string
    end

    create unique_index(:vendedores, [:ddd, :telefone], name: :telefone_ddd_vendedor)
    create unique_index(:vendedores, :cnpj_cpf)
    create unique_index(:vendedores, :email)
  end
end
