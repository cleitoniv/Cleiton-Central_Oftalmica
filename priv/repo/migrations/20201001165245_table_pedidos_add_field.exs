defmodule Tecnovix.Repo.Migrations.TablePedidosAddField do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :loja, :string
      add :integrado, :string
    end
  end
end
