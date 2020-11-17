defmodule Tecnovix.Repo.Migrations.EnderecoVarchar255 do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :endereco
      add :endereco, :string
    end
  end
end
