defmodule Tecnovix.PedidosDeVendaSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.ItensDosPedidosDeVendaSchema

  schema "pedidos_de_venda" do
    field :cliente_id, :integer
    field :filial, :string
    field :numero, :string
    field :cliente, :string
    field :tipo_venda, :string
    field :tipo_venda_ret_id, :integer
    field :pd_correios, :string
    field :vendedor_1, :string
    field :status_ped, :integer

    has_many :items, ItensDosPedidosDeVendaSchema,
      foreign_key: :pedido_de_venda_id,
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :filial,
      :numero,
      :cliente,
      :tipo_venda,
      :tipo_venda_ret_id,
      :pd_correios,
      :vendedor_1,
      :status_ped
    ])
    |> validate_required([:cliente_id, :filial])
    |> cast_assoc(:items)
  end
end
