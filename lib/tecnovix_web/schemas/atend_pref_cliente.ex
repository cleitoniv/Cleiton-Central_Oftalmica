defmodule Tecnovix.AtendPrefClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "atend_pref_cliente" do
    field :cod_cliente, :string
    field :loja_cliente, :string
    field :seg_manha, :integer
    field :seg_tarde, :integer
    field :ter_manha, :integer
    field :ter_tarde, :integer
    field :qua_manha, :integer
    field :qua_tarde, :integer
    field :qui_manha, :integer
    field :qui_tarde, :integer
    field :sex_manha, :integer
    field :sex_tarde, :integer
    field :sab_manha, :integer
    field :sab_tarde, :integer
    field :observacoes, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cod_cliente,
      :loja_cliente,
      :seg_manha,
      :seg_tarde,
      :ter_manha,
      :ter_tarde,
      :qua_manha,
      :qua_tarde,
      :qui_manha,
      :qui_tarde,
      :sex_manha,
      :sex_tarde,
      :sab_manha,
      :sab_tarde,
      :observacoes
    ])
    |> validate_required([:cod_cliente])
  end
end
