defmodule Tecnovix.Repo.Migrations.CreateUniqueCartao do
  use Ecto.Migration

  def change do
    create unique_index(:cartao_credito_cliente, :cartao_number)
  end
end
