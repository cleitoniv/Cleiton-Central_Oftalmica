defmodule Tecnovix.Repo.Migrations.RemoveTipoVenda do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      remove :tipo_venda
    end
  end
end
