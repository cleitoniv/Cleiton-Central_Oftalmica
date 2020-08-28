defmodule Tecnovix.Repo.Migrations.Products do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :value, :integer
      add :image_url, :string
      add :type, :string
      add :description, :string
      add :material, :string
      add :dk_t, :integer
      add :visint, :boolean
      add :espessura, :string
      add :hidratacao, :string
      add :assepsia, :string
      add :descarte, :string
      add :desenho, :string
      add :diametro, :string
      add :curva_base, :integer
      add :esferico, :string
    end
  end
end
