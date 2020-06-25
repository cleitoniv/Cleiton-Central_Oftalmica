defmodule Tecnovix.Repo.Migrations.PreDevolucao do
  use Ecto.Migration

  def change do
    create table(:pre_devolucao) do
      add :cliente_id, :integer
      add :filial, :string, size: 4
      add :cod_pre_dev, :string, size: 6
      add :tipo_pre_dev, :string, size: 1
      add :inclusao, :date
      add :cliente, :string, size: 6
      add :loja, :string, size: 2
      add :status, :string, size: 1

      timestamps()
    end
  end
end
