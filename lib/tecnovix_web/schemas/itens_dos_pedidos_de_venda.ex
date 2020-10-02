defmodule Tecnovix.ItensDosPedidosDeVendaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itens_dos_pedidos_de_venda" do
    belongs_to :descricao_generica_do_produto, Tecnovix.DescricaoGenericaDoProdutoSchema
    field :filial, :string
    field :nocontrato, :string
    field :operation, :string
    field :produto, :string
    field :quantidade, :integer
    field :prc_unitario, :integer
    field :tipo_venda, :string
    field :olho, :string
    field :paciente, :string
    field :num_pac, :string
    field :dt_nas_pac, :date
    field :virtotal, :integer
    field :esferico, :decimal
    field :cilindrico, :decimal
    field :eixo, :decimal
    field :cor, :string
    field :adic_padrao, :string
    field :adicao, :decimal
    field :nota_fiscal, :string
    field :serie_nf, :string
    field :num_pedido, :string
    field :url_image, :string
    field :codigo_item, :string
    field :codigo, :string
    field :tests, :string
    field :grupo, :string
    belongs_to :pedido_de_venda, Tecnovix.PedidosDeVendaSchema
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :filial,
      :codigo,
      :tests,
      :grupo,
      :nocontrato,
      :tipo_venda,
      :codigo_item,
      :produto,
      :quantidade,
      :prc_unitario,
      :olho,
      :paciente,
      :num_pac,
      :dt_nas_pac,
      :virtotal,
      :operation,
      :esferico,
      :cilindrico,
      :eixo,
      :cor,
      :adic_padrao,
      :adicao,
      :nota_fiscal,
      :serie_nf,
      :num_pedido,
      :url_image
    ])
    |> validate_required([
      :pedido_de_venda_id,
      :produto,
      :quantidade
    ])
  end

  def changeset_sync(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :filial,
      :codigo,
      :nocontrato,
      :tipo_venda,
      :codigo_item,
      :produto,
      :quantidade,
      :prc_unitario,
      :olho,
      :paciente,
      :num_pac,
      :dt_nas_pac,
      :virtotal,
      :operation,
      :esferico,
      :cilindrico,
      :eixo,
      :cor,
      :adic_padrao,
      :adicao,
      :nota_fiscal,
      :serie_nf,
      :num_pedido,
      :url_image
    ])
    |> validate_required([
      :produto,
      :quantidade
    ])
  end
end
