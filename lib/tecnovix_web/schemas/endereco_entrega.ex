defmodule Tecnovix.EnderecoEntregaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "endereco_entrega" do
    field :cep_entrega, :string
    field :numero_entrega, :string
    field :complemento_entrega, :string
    field :bairro_entrega, :string
    field :cidade_entrega, :string
    field :endereco_entrega, :string
    field :estado_entrega, :string
    belongs_to :cliente, Tecnovix.ClientesSchema

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :cep_entrega,
      :numero_entrega,
      :complemento_entrega,
      :bairro_entrega,
      :cidade_entrega,
      :endereco_entrega,
      :cliente_id,
      :estado_entrega
    ])
  end
end
