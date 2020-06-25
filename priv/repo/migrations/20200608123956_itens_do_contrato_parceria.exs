defmodule Tecnovix.Repo.Migrations.ItensDoContratoParceria do
  use Ecto.Migration

  def change do
    create table(:itens_do_contrato_parceria) do
      add :contrato_de_parceria_id, :integer
      add :descricao_generica_do_produto_id, :integer
      add :filial, :string, size: 4
      add :contrato_n, :string, size: 6
      add :item, :string, size: 2
      add :produto, :string, size: 15
      add :quantidade, :decimal
      add :preco_venda, :decimal
      add :total, :decimal
      add :cliente, :string
      add :loja, :string

      timestamps()
    end
  end
end
