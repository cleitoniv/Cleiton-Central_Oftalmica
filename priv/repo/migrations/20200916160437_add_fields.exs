defmodule Tecnovix.Repo.Migrations.AddFields do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      add :paciente, :string
      add :numero, :integer
      add :dt_nas_pac, :date
      add :esferico, :decimal
      add :cilindrico, :decimal
      add :eixo, :decimal
      add :cor, :string, size: 20
      add :adicao, :decimal
    end
  end
end
