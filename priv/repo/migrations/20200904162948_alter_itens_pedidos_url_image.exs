defmodule Tecnovix.Repo.Migrations.AlterItensPedidosUrlImage do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :url_image, :string
    end
  end
end
