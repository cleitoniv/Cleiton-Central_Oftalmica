defmodule Tecnovix.Repo.Migrations.PedidosDeVenda do
  use Ecto.Migration

  def change do
    create table(:pedidos_de_venda) do
      add :cliente_id, :integer
      add :filial, :string, size: 4
      add :numero, :string, size: 6
      add :cliente, :string, size: 6
      add :tipo_venda, :string, size: 1
      add :tipo_venda_ret_id, :integer
      add :pd_correios, :string, size: 1
      add :vendedor_1, :string, size: 6
      add :status_ped, :integer

      timestamps()
    end
  end
end
