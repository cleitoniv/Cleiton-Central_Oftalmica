defmodule Tecnovix.ItensPreDevolucaoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itens_pre_devolucao" do
    field :descricao_generica_do_produto_id, :integer
    field :sub_descricao_generica_do_produto_id, :integer
    field :filial, :string
    field :cod_pre_dev, :string
    field :item, :string
    field :filial_orig, :string
    field :num_de_serie, :string
    field :produto, :string
    field :quant, :decimal
    field :prod_subs, :string
    field :descricao, :string
    field :doc_devol, :string
    field :serie, :string
    field :doc_saida, :string
    field :serie_saida, :string
    field :item_doc, :string
    field :contrato, :string
    field :tipo, :string
    belongs_to :pre_devolucao, Tecnovix.PreDevolucaoSchema

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :pre_devolucao_id,
      :descricao_generica_do_produto_id,
      :sub_descricao_generica_do_produto_id,
      :filial,
      :cod_pre_dev,
      :item,
      :filial_orig,
      :num_de_serie,
      :produto,
      :quant,
      :prod_subs,
      :descricao,
      :doc_devol,
      :serie,
      :doc_saida,
      :serie_saida,
      :item_doc,
      :contrato,
      :tipo
    ])
    |> validate_required([
      :pre_devolucao_id,
      :descricao_generica_do_produto_id,
      :sub_descricao_generica_do_produto_id
    ])
  end
end
