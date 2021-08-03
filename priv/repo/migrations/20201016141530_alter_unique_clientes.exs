defmodule Tecnovix.Repo.Migrations.AlterUniqueClientes do
  use Ecto.Migration

  def change do
    drop index(:clientes, :codigo)
    create unique_index(:clientes, [:codigo, :loja], name: :loja_codigo)
  end
end
