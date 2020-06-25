defmodule Tecnovix.CreditoFinanceiroSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credito_financeiro" do
    field :cliente_id, :integer
    field :valor, :decimal
    field :desconto, :integer
    field :tipo_pagamento, :string
    field :wirecard_pedido_id, :string
    field :wirecard_pagemento_id, :string
    field :wirecard_reembolso_id, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :valor,
      :desconto,
      :tipo_pagamento,
      :wirecard_pedido_id,
      :wirecard_pagemento_id,
      :wirecard_reembolso_id
    ])
    |> validate_required([:cliente_id])
  end
end
