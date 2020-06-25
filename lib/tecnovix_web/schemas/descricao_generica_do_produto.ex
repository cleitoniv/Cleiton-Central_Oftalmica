defmodule Tecnovix.DescricaoGenericaDoProdutoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "descricao_generica_do_produto" do
    field :grupo, :string
    field :codigo, :string
    field :descricao, :string
    field :esferico, :decimal
    field :cilindrico, :decimal
    field :eixo, :integer
    field :cor, :string
    field :diametro, :decimal
    field :curva_base, :decimal
    field :adic_padrao, :string
    field :adicao, :decimal
    field :raio_curva, :string
    field :link_am_app, :string
    field :blo_de_tela, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:grupo, :codigo, :descricao, :esferico, :cilindrico, :eixo, :cor, :diametro, :curva_base, :adic_padrao,
    :adicao, :raio_curva, :link_am_app, :blo_de_tela])
  end
end
