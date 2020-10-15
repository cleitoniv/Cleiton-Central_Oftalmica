defmodule Tecnovix.Repo.Migrations.UniqueIndexClientes do
  use Ecto.Migration

  def change do
    create unique_index(:clientes, [:uid])
    create unique_index(:clientes, [:codigo])
    create unique_index(:clientes, [:email])
    create unique_index(:clientes, [:cnpj_cpf])
  end
end
