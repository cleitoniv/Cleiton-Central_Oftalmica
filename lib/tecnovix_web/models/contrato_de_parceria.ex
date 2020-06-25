defmodule Tecnovix.ContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContratoDeParceriaSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(ContratoDeParceriaSchema, filial: params["filial"]),
         nil <- Repo.get_by(ContratoDeParceriaSchema, contrato_n: params["contrato_n"]) do
          create(params)
    else
      contrato ->
        {:ok, contrato}
    end
  end
end
