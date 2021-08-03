defmodule Tecnovix.App.DetailOrderModel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :paciente, :string
    field :cliente, :integer
    field :data_nascimento, :date
    field :olhos, :string
    field :grau, :string
    field :cilindro, :string
    field :eixo, :integer
    field :quantidade, :integer
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :paciente,
      :cliente,
      :data_nascimento,
      :olhos,
      :grau,
      :cilindro,
      :eixo,
      :quantidade
    ])
    |> validate_required([
      :paciente,
      :cliente,
      :data_nascimento,
      :olhos,
      :grau,
      :cilindro,
      :eixo,
      :quantidade
    ])
  end
end
