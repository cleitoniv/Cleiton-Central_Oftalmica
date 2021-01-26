defmodule Tecnovix.Repo.Migrations.DeliveryAddress do
  use Ecto.Migration

  def change do
    create table(:endereco_entrega) do
      add :cep_entrega, :string
      add :numero_entrega, :string
      add :complemento_entrega, :string
      add :bairro_entrega, :string
      add :cidade_entrega, :string
      add :endereco_entrega, :string
      add :estado_entrega, :string
      add :cliente_id, references(:clientes)

      timestamps()
    end
  end
end
