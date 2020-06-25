defmodule Tecnovix.ContasAReceberSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contas_a_receber" do
    field :cliente_id, :integer
    field :filial, :string
    field :no_titulo, :string
    field :tipo, :string
    field :cliente, :string
    field :loja, :string
    field :dt_emissao, :date
    field :vencto_real, :date
    field :virtitulo, :decimal
    field :saldo, :decimal
    field :cod_barras, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,[:cliente_id, :filial, :no_titulo, :tipo, :cliente, :loja, :dt_emissao, :vencto_real, :virtitulo,
    :saldo, :cod_barras])
    |> validate_required([:cliente_id, :filial])
  end
end
