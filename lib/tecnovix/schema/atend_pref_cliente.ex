defmodule Tecnovix.AtendPrefClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "atend_pref_cliente" do
    field :cliente_id, :integer
    field :cod_cliente, :string
    field :loja_cliente, :string
    field :seg_manha, :integer, default: 0
    field :seg_tarde, :integer, default: 0
    field :ter_manha, :integer, default: 0
    field :ter_tarde, :integer, default: 0
    field :qua_manha, :integer, default: 0
    field :qua_tarde, :integer, default: 0
    field :qui_manha, :integer, default: 0
    field :qui_tarde, :integer, default: 0
    field :sex_manha, :integer, default: 0
    field :sex_tarde, :integer, default: 0
    field :sab_manha, :integer, default: 0
    field :sab_tarde, :integer, default: 0
    field :observacoes, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,[:cliente_id, :cod_cliente, :loja_cliente, :seg_manha, :seg_tarde, :ter_manha, :ter_tarde, :qua_manha,
    :qua_tarde, :qui_manha, :qui_tarde, :sex_manha, :sex_tarde, :sab_manha, :sab_tarde, :observacoes])
    |> validate_required([:cod_cliente])
    |> validate_fields(:seg_manha)
    |> validate_fields(:seg_tarde)
    |> validate_fields(:ter_manha)
    |> validate_fields(:ter_tarde)
    |> validate_fields(:qua_manha)
    |> validate_fields(:qua_tarde)
    |> validate_fields(:qui_manha)
    |> validate_fields(:qui_tarde)
    |> validate_fields(:sex_manha)
    |> validate_fields(:sex_tarde)
    |> validate_fields(:sab_manha)
    |> validate_fields(:sab_tarde)
  end

  def validate_fields(changeset, dia) do
    cond do
      get_field(changeset, dia) == 1 ->
        changeset
      true ->
        put_change(changeset, dia, 0)
    end
  end
end
