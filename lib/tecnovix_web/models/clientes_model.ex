defmodule Tecnovix.ClientesModel do
  use Tecnovix.DAO, schema: Tecnovix.ClientesSchema
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema

  def insert_or_update(params) do
    case Repo.get_by(ClientesSchema, cnpj_cpf: params["cnpj_cpf"]) do
      nil ->
        create(params)
      cliente -> {:ok, cliente}
    end
  end
end
