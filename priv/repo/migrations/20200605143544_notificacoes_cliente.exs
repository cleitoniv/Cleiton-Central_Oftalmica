defmodule Tecnovix.Repo.Migrations.NotificacoesCliente do
  use Ecto.Migration

  def change do
    create table(:notificacoes_cliente) do
      add :cliente_id, references(:clientes)
      add :data, :utc_datetime
      add :titulo, :string, size: 255
      add :descricao, :string
      add :enviado, :integer
      add :lido, :integer
      add :tipo_ref, :string
      add :tipo_ref_id, :integer

      timestamps()
    end
  end
end
