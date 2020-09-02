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
    field :tipo_venda, :string
    field :tipo_venda_ret_id, :integer
    field :pd_correios, :string
    field :vendedor_1, :string
    field :status_ped, :integer, default: 0
    field :operation, :string

    has_many :items, ItensDosPedidosDeVendaSchema,
      foreign_key: :pedido_de_venda_id,
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :order_id,
      :client_id,
      :filial,
      :numero,
      :cliente,
      :tipo_venda,
      :tipo_venda_ret_id,
      :pd_correios,
      :vendedor_1,
      :status_ped,
      :operation
    ])
    |> validate_required([:client_id])
    |> cast_assoc(:items)
  end
end
