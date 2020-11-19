defmodule Tecnovix.Repo.Migrations.RemoveFieldFilialNumero do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      remove :filial
      remove :numero
    end
  end
end
