defmodule Tecnovix.ContratoDeParceriaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contrato_de_parceria" do
    field :cliente_id, :integer
    field :filial, :string
    field :contrato_n, :string
    field :docto_orig, :string
    field :emissao, :date
    field :cliente, :string
    field :loja, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :filial, :contrato_n, :docto_orig, :emissao, :cliente, :loja])
    |> validate_required([:cliente_id, :filial, :contrato_n])
  end
end
