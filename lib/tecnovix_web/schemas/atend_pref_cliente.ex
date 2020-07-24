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
    |> validate_seg_manha()
    |> validate_seg_tarde()
    |> validate_ter_manha()
    |> validate_ter_tarde()
    |> validate_qua_manha()
    |> validate_qua_tarde()
    |> validate_qui_manha()
    |> validate_qui_tarde()
    |> validate_sex_manha()
    |> validate_sex_tarde()
    |> validate_sab_manha()
    |> validate_sab_tarde()
  end

  def validate_seg_manha(changeset) do
    cond do
      get_field(changeset, :seg_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :seg_manha, 0)
    end
  end

  def validate_seg_tarde(changeset) do
    cond do
      get_field(changeset, :seg_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :seg_tarde, 0)
    end
  end

  def validate_ter_manha(changeset) do
    cond do
      get_field(changeset, :ter_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :ter_manha, 0)
    end
  end

  def validate_ter_tarde(changeset) do
    cond do
      get_field(changeset, :ter_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :ter_tarde, 0)
    end
  end

  def validate_qua_manha(changeset) do
    cond do
      get_field(changeset, :qua_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :qua_manha, 0)
    end
  end

  def validate_qua_tarde(changeset) do
    cond do
      get_field(changeset, :qua_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :qua_tarde, 0)
    end
  end

  def validate_qui_manha(changeset) do
    cond do
      get_field(changeset, :qui_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :qui_manha, 0)
    end
  end

  def validate_qui_tarde(changeset) do
    cond do
      get_field(changeset, :qui_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :qui_tarde, 0)
    end
  end

  def validate_sex_manha(changeset) do
    cond do
      get_field(changeset, :sex_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :sex_manha, 0)
    end
  end

  def validate_sex_tarde(changeset) do
    cond do
      get_field(changeset, :sex_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :sex_tarde, 0)
    end
  end

  def validate_sab_manha(changeset) do
    cond do
      get_field(changeset, :sab_manha) == 1 ->
        changeset
      true ->
        put_change(changeset, :sab_manha, 0)
    end
  end

  def validate_sab_tarde(changeset) do
    cond do
      get_field(changeset, :sab_tarde) == 1 ->
        changeset
      true ->
        put_change(changeset, :sab_tarde, 0)
    end
  end
end
