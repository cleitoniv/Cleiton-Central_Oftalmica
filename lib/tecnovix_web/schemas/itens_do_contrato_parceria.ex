defmodule Tecnovix.ItensDoContratoParceriaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itens_do_contrato_parceria" do
    field :descricao_generica_do_produto_id, :integer
    field :filial, :string
    field :contrato_n, :string
    field :item, :string
    field :produto, :string
    field :quantidade, :decimal
    field :preco_venda, :decimal
    field :total, :decimal
    field :cliente, :string
    field :loja, :string
    belongs_to :contrato_de_parceria, Tecnovix.ContratoDeParceriaSchema

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :contrato_de_parceria_id,
      :descricao_generica_do_produto_id,
      :filial,
      :contrato_n,
      :item,
      :produto,
      :quantidade,
      :preco_venda,
      :total,
      :cliente,
      :loja
    ])
    |> validate_required([:contrato_de_parceria_id, :descricao_generica_do_produto_id, :filial])
  end
end
