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

    has_many :items, Tecnovix.ItensDoContratoParceriaSchema,
      foreign_key: :contrato_de_parceria_id,
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:client_id, :filial, :contrato_n, :docto_orig, :emissao, :cliente, :loja])
    |> validate_required([:client_id, :filial, :contrato_n])
    |> cast_assoc(:items)
  end
end
