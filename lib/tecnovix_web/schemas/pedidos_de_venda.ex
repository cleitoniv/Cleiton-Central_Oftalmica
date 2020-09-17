defmodule Tecnovix.PedidosDeVendaSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.ItensDosPedidosDeVendaSchema

  schema "pedidos_de_venda" do
    belongs_to :client, Tecnovix.ClientesSchema
    field :order_id, :string
    field :filial, :string
    field :numero, :string
    field :cliente, :string
    field :tipo_venda_ret_id, :integer
    field :pd_correios, :string
    field :vendedor_1, :string
    field :status_ped, :integer, default: 0
    field :previsao_entrega, :string
    field :frete, :integer, default: 0
    has_one :contrato_de_parceria, Tecnovix.ContratoDeParceriaSchema

    has_many :items, ItensDosPedidosDeVendaSchema,
      foreign_key: :pedido_de_venda_id,
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :previsao_entrega,
      :frete,
      :order_id,
      :client_id,
      :filial,
      :numero,
      :cliente,
      :tipo_venda_ret_id,
      :pd_correios,
      :vendedor_1,
      :status_ped
    ])
    |> validate_required([:client_id])
    |> cast_assoc(:items)
    |> cast_assoc(:contrato_de_parceria)
  end

  def changeset_sync(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :previsao_entrega,
      :frete,
      :order_id,
      :client_id,
      :filial,
      :numero,
      :cliente,
      :tipo_venda_ret_id,
      :pd_correios,
      :vendedor_1,
      :status_ped
    ])
    |> cast_assoc(:items)
    |> cast_assoc(:contrato_de_parceria)
  end
end
