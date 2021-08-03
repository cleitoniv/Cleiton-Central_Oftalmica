defmodule Tecnovix.Repo.Migrations.AlterPedidos do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :tipo_pagamento, :string
      add :parcela, :integer
    end
  end
end
