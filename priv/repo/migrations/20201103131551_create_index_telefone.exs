defmodule Tecnovix.Repo.Migrations.CreateIndexTelefone do
  use Ecto.Migration

  def change do
    create unique_index(:clientes, [:telefone, :cnpj_cpf], name: :telefone_unico)
  end
end
