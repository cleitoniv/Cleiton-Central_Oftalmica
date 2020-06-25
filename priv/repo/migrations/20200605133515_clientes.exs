defmodule Tecnovix.Repo.Migrations.Clientes do
  use Ecto.Migration

  def change do
    create table(:clientes) do
      add :uid, :string, size: 45
      add :codigo, :string, size: 6
      add :loja, :string, size: 2
      add :fisica_jurid, :string
      add :cnpj_cpf, :string, size: 14
      add :data_nascimento, :date
      add :nome, :string, size: 70
      add :nome_empresarial, :string, size: 255
      add :email, :string, size: 250
      add :endereco, :string, size: 40
      add :numero, :string, size: 45
      add :complemento, :string, size: 50
      add :bairro, :string, size: 30
      add :cep, :string, size: 8
      add :cdmunicipio, :string, size: 5
      add :municipio, :string, size: 45
      add :ddd, :string, size: 3
      add :telefone, :string, size: 15
      add :bloqueado, :string, size: 1
      add :sit_app, :string, size: 1
      add :cod_cnae, :string, size: 9
      add :ramo, :string, size: 1
      add :vendedor, :string, size: 6
      add :crm_medico, :string, size: 6
      add :dia_remessa, :string, size: 1
      add :wirecard_client_id, :string, size: 45
      add :fcm_token, :string, size: 255

      timestamps()
    end

    create unique_index(:clientes, :uid)
    create unique_index(:clientes, :codigo)
    create unique_index(:clientes, :email)
    create unique_index(:clientes, :cnpj_cpf)
  end
end
