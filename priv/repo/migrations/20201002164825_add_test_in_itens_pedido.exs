defmodule Tecnovix.Repo.Migrations.AddTestInItensPedido do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :tests, :string
    end
  end
end
