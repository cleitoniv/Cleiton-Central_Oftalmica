defmodule Tecnovix.Repo.Migrations.ContasAReceber do
  use Ecto.Migration

  def change do
    create table(:contas_a_receber) do
      add :cliente_id, :integer
      add :filial, :string, size: 4
      add :no_titulo, :string, size: 9
      add :tipo, :string, size: 3
      add :cliente, :string, size: 6
      add :loja, :string, size: 2
      add :dt_emissao, :date
      add :vencto_real, :date
      add :virtitulo, :decimal
      add :saldo, :decimal
      add :cod_barras, :string, size: 44

      timestamps()
    end
  end
end
