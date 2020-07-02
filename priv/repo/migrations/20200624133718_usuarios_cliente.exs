defmodule Tecnovix.Repo.Migrations.UsuariosCliente do
  use Ecto.Migration

  def change do
    create table(:usuarios_cliente) do
      add :cliente_id, references(:clientes)
      add :uid, :string, size: 45
      add :nome, :string, size: 255
      add :email, :string, size: 255
      add :cargo, :string, size: 255
      add :status, :integer
      add :senha_enviada, :integer

      timestamps()
    end

    create unique_index(:usuarios_cliente, :cliente_id)
  end
end
