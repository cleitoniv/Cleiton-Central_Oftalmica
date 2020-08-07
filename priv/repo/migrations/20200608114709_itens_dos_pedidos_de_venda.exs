defmodule Tecnovix.Repo.Migrations.ItensDosPedidosDeVenda do
  use Ecto.Migration

  def change do
    create table(:itens_dos_pedidos_de_venda) do
      add :pedido_de_venda_id, :integer
      add :descricao_generica_do_produto_id, :integer
      add :filial, :string, size: 6
      add :nocontrato, :string, size: 6
      add :produto, :string, size: 15
      add :quantidade, :decimal
      add :prc_unitario, :decimal
      add :olho, :string, size: 1
      add :paciente, :string, size: 50
      add :num_pac, :string, size: 20
      add :dt_nas_pac, :string, size: 8
      add :virtotal, :decimal
      add :esferico, :decimal
      add :cilindrico, :decimal
      add :eixo, :integer
      add :cor, :string, size: 30
      add :adic_padrao, :string, size: 7
      add :adicao, :decimal
      add :nota_fiscal, :string, size: 9
      add :serie_nf, :string, size: 3
      add :num_pedido, :string, size: 6

      timestamps()
    end
  end
end
