defmodule Tecnovix.ItensDosPedidosDeVendaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itens_dos_pedidos_de_venda" do
    belongs_to :descricao_generica_do_produto_id, Tecnovix.DescricaoGenericaDoProdutoSchema
    field :filial, :string
    field :nocontrato, :string
    field :produto, :string
    field :quantidade, :decimal
    field :prc_unitario, :decimal
    field :olho, :string
    field :paciente, :string
    field :num_pac, :string
    field :dt_nas_pac, :string
    field :virtotal, :decimal
    field :esferico, :decimal
    field :cilindrico, :decimal
    field :eixo, :integer
    field :cor, :string
    field :adic_padrao, :string
    field :adicao, :decimal
    field :nota_fiscal, :string
    field :serie_nf, :string
    field :num_pedido, :string
    belongs_to :pedido_de_venda, Tecnovix.PedidosDeVendaSchema
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :filial,
      :nocontrato,
      :produto,
      :quantidade,
      :prc_unitario,
      :olho,
      :paciente,
      :num_pac,
      :dt_nas_pac,
      :virtotal,
      :esferico,
      :cilindrico,
      :eixo,
      :cor,
      :adic_padrao,
      :adicao,
      :nota_fiscal,
      :serie_nf,
      :num_pedido
    ])
    |> validate_required([
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :produto,
      :quantidade
    ])
  end
end
