defmodule Tecnovix.Repo.Migrations.AlterCpfTitularCc do
  use Ecto.Migration

  def change do
    alter table(:cartao_credito_cliente) do
      remove :cpf_titular
      add :cpf_cnpj_titular, :string
    end
  end
end
