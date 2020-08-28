defmodule Tecnovix.PreDevolucaoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pre_devolucao" do
    belongs_to :client, Tecnovix.ClientesSchema
    field :filial, :string
    field :cod_pre_dev, :string
    field :tipo_pre_dev, :string
    field :inclusao, :date, autogenerate: {Date, :utc_today, []}
    field :cliente, :string
    field :loja, :string
    field :status, :string, default: "0"

    has_many :items, Tecnovix.ItensPreDevolucaoSchema,
      foreign_key: :pre_devolucao_id,
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :client_id,
      :filial,
      :cod_pre_dev,
      :tipo_pre_dev,
      :inclusao,
      :cliente,
      :loja,
      :status
    ])
    |> validate_required([:client_id, :filial, :cod_pre_dev, :tipo_pre_dev])
    |> cast_assoc(:items)
  end
end
