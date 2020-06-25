defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.PreDevolucaoSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: params["filial"]),
         nil <- Repo.get_by(PreDevolucaoSchema, cod_pre_dev: params["cod_pre_dev"]) do
          create(params)
    else
      devolucao ->
        {:ok, devolucao}
    end
  end
end
