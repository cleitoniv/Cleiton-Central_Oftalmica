defmodule Tecnovix.ContratoDeParceriaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contrato_de_parceria" do
    belongs_to :client, Tecnovix.ClientesSchema
    field :filial, :string
    field :contrato_n, :string
    field :docto_orig, :string
    field :emissao, :date, autogenerate: {Date, :utc_today, []}
    field :cliente, :string
    field :loja, :string
    field :order_id, :string

    has_many :items, Tecnovix.ItensDoContratoParceriaSchema,
      foreign_key: :contrato_de_parceria_id,
      on_replace: :delete

    timestamps()
  end

  # RETIREI A VALIDACAO REQUIRIDA DOS CAMPOS: contrato_n e filial
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :client_id,
      :filial,
      :contrato_n,
      :docto_orig,
      :emissao,
      :cliente,
      :loja,
      :order_id
    ])
    |> validate_required([:client_id])
    |> cast_assoc(:items)
  end
end
