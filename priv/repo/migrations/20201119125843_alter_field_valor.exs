defmodule Tecnovix.Repo.Migrations.AlterFieldValor do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :valor_credito_finan
      remove :valor_credito_prod
      add :valor_credito_finan, :integer
      add :valor_credito_prod, :integer
    end
  end
end
