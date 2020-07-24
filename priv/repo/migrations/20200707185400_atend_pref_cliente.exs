defmodule Tecnovix.Repo.Migrations.AtendPrefCliente do
  use Ecto.Migration

  def change do
    create table(:atend_pref_cliente) do
      add :cliente_id, :integer
      add :cod_cliente, :string, size: 6
      add :loja_cliente, :string, size: 2
      add :seg_manha, :integer
      add :seg_tarde, :integer
      add :ter_manha, :integer
      add :ter_tarde, :integer
      add :qua_manha, :integer
      add :qua_tarde, :integer
      add :qui_manha, :integer
      add :qui_tarde, :integer
      add :sex_manha, :integer
      add :sex_tarde, :integer
      add :sab_manha, :integer
      add :sab_tarde, :integer
      add :observacoes, :string, size: 250

      timestamps()
    end

    create unique_index(:atend_pref_cliente, :cod_cliente)
  end
end
