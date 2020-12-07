defmodule Tecnovix.Repo.Migrations.CreateFieldValor do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :valor_credito_finan, :string
      add :valor_credito_prod, :string
    end
  end
end
