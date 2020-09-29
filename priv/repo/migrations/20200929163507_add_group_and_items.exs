defmodule Tecnovix.Repo.Migrations.AddGroupAndItems do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :grupo, :string
    end
  end
end
