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
    field :prc_unitario, :integer, default: 0
    field :tipo_venda, :string
    field :olho, :string
    field :status, :integer, default: 0
    field :paciente, :string
    field :num_pac, :string
    field :duracao, :string, default: "0 dias"
    field :dt_nas_pac, :date
    field :virtotal, :integer
    field :valor_credito_finan, :integer, default: 0
    field :valor_credito_prod, :integer, default: 0
    field :valor_test, :integer, default: 0
    field :esferico, :decimal
    field :cilindrico, :decimal
    field :eixo, :integer
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
    field :percentage_test, :integer, default: 0
    field :produto_teste, :string
    belongs_to :pedido_de_venda, Tecnovix.PedidosDeVendaSchema

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :status,
      :valor_credito_finan,
      :valor_credito_prod,
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :filial,
      :duracao,
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
      :url_image,
      :valor_test,
      :percentage_test,
      :produto_teste
    ])
    |> validate_required([
      :pedido_de_venda_id
    ])
  end

  def changeset_sync(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :status,
      :valor_credito_finan,
      :valor_credito_prod,
      :pedido_de_venda_id,
      :descricao_generica_do_produto_id,
      :filial,
      :duracao,
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
      :url_image,
      :valor_test,
      :percentage_test,
      :produto_teste
    ])
  end
end
