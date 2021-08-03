defmodule Tecnovix.Repo.Migrations.CreateFieldDuracao do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :duracao, :string
    end
  end
end
