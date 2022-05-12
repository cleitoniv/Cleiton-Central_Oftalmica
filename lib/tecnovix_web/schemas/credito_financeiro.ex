defmodule Tecnovix.CreditoFinanceiroSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credito_financeiro" do
    belongs_to(:cliente, Tecnovix.ClientesSchema)
    field(:valor, :integer)
    field(:desconto, :integer)
    field(:prestacoes, :integer)
    field(:tipo_pagamento, :string)
    field(:wirecard_pedido_id, :string)
    field(:wirecard_pagamento_id, :string)
    field(:wirecard_reembolso_id, :string)
    field(:status, :integer, default: 0)
    field(:saldo, :integer, default: 0)
    field(:pago, :integer, default: 0)
    timestamps()
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :valor,
      :desconto,
      :prestacoes,
      :tipo_pagamento,
      :wirecard_pedido_id,
      :wirecard_pagamento_id,
      :wirecard_reembolso_id,
      :status,
      :saldo,
      :pago
    ])
  end
end
