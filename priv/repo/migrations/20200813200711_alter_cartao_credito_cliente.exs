defmodule Tecnovix.Repo.Migrations.AlterCartaoCreditoCliente do
  use Ecto.Migration

  def change do
    alter table(:cartao_credito_cliente) do
      remove :cliente_id
      add :cliente_id, references(:clientes)
    end
  end
end
