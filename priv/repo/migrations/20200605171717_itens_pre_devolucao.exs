defmodule Tecnovix.Repo.Migrations.ItensPreDevolucao do
  use Ecto.Migration

  def change do
    create table(:itens_pre_devolucao) do
      add :pre_devolucao_id, :integer
      add :descricao_generica_do_produto_id, :integer
      add :sub_descricao_generica_do_produto_id, :integer
      add :filial, :string, size: 4
      add :cod_pre_dev, :string, size: 6
      add :item, :string, size: 2
      add :filial_orig, :string, size: 4
      add :num_de_serie, :string, size: 20
      add :produto, :string, size: 15
      add :quant, :decimal
      add :prod_subs, :string, size: 15
      add :descricao, :string, size: 60
      add :doc_devol, :string, size: 9
      add :serie, :string, size: 3
      add :doc_saida, :string, size: 15
      add :serie_saida, :string, size: 3
      add :item_doc, :string, size: 2
      add :contrato, :string, size: 6
      add :tipo, :string, size: 3

      timestamps()
    end
  end
end
