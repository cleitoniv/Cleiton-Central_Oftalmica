defmodule Tecnovix.ItensPreDevolucaoSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.DescricaoGenericaDoProdutoSchema

  schema "itens_pre_devolucao" do
    belongs_to :descricao_generica_do_produto, DescricaoGenericaDoProdutoSchema
    field :sub_descricao_generica_do_produto_id, :integer
    field :filial, :string
    field :cod_pre_dev, :string
    field :item, :string
    field :filial_orig, :string
    field :num_de_serie, :string
    field :produto, :string
    field :quant, :integer
    field :prod_subs, :string
    field :descricao, :string
    field :doc_devol, :string
    field :serie, :string
    field :doc_saida, :string
    field :serie_saida, :string
    field :item_doc, :string
    field :contrato, :string
    field :tipo, :string
    field :paciente, :string
    field :numero, :string
    field :dt_nas_pac, :string
    field :esferico, :decimal
    field :cilindrico, :decimal
    field :eixo, :decimal
    field :cor, :string
    field :olho, :string
    field :adicao, :decimal
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
      :olho,
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
      :tipo,
      :cor,
      :adicao,
      :esferico,
      :cilindrico,
      :eixo,
      :paciente,
      :dt_nas_pac,
      :numero
    ])
    |> unique_constraint([:num_de_serie], message: "Esse número de série ja está em um processo de devolução.")
  end
end
