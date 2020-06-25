defmodule Tecnovix.VendedoresModel do
  use Tecnovix.DAO, schema: Tecnovix.VendedoresSchema
  alias Tecnovix.Repo
  alias Tecnovix.VendedoresSchema

  def insert_or_update(params) do
    case Repo.get_by(VendedoresSchema, cnpj_cpf: params["cnpj_cpf"]) do
      nil ->
        create(params)
      vendedor -> {:ok, vendedor}
    end
  end
end
