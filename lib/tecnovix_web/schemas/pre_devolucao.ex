defmodule Tecnovix.PreDevolucaoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pre_devolucao" do
    field :cliente_id, :integer
    field :filial, :string
    field :cod_pre_dev, :string
    field :tipo_pre_dev, :string
    field :inclusao, :date
    field :cliente, :string
    field :loja, :string
    field :status, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :filial,
      :cod_pre_dev,
      :tipo_pre_dev,
      :inclusao,
      :cliente,
      :loja,
      :status
    ])
    |> validate_required([:cliente_id, :filial, :cod_pre_dev, :tipo_pre_dev])
  end
end
