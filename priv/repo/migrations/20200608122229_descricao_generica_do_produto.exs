defmodule Tecnovix.Repo.Migrations.DescricaoGenericaDoProduto do
  use Ecto.Migration

  def change do
    create table(:descricao_generica_do_produto) do
      add :grupo, :string, size: 4
      add :codigo, :string, size: 15
      add :descricao, :string, size: 60
      add :esferico, :decimal
      add :cilindrico, :decimal
      add :eixo, :integer
      add :cor, :string, size: 30
      add :diametro, :decimal
      add :curva_base, :decimal
      add :adic_padrao, :string, size: 7
      add :adicao, :decimal
      add :raio_curva, :string, size: 13
      add :link_am_app, :string, size: 244
      add :blo_de_tela, :string, size: 1

      timestamps()
    end
  end
end
