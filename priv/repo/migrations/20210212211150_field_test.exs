defmodule Tecnovix.Repo.Migrations.FieldTest do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :produto_com_teste, :string
    end
  end
end
