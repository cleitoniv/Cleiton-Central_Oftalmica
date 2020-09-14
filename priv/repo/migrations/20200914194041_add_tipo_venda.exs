defmodule Tecnovix.Repo.Migrations.AddTipoVenda do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :tipo_venda, :string, size: 1
    end
  end
end
