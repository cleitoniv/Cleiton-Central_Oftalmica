defmodule Tecnovix.Repo.Migrations.ContratoDeParceria do
  use Ecto.Migration

  def change do
    create table(:contrato_de_parceria) do
      add :cliente_id, :integer
      add :filial, :string, size: 4
      add :contrato_n, :string, size: 6
      add :docto_orig, :string, size: 9
      add :emissao, :date
      add :cliente, :string, size: 6
      add :loja, :string, size: 2

      timestamps()
    end
  end
end
