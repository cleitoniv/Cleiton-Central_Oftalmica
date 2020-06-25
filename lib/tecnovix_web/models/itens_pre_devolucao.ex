defmodule Tecnovix.ItensPreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensPreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensPreDevolucaoSchema, as: ItensSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(ItensSchema, filial: params["filial"]),
         nil <- Repo.get_by(ItensSchema, cod_pre_dev: params["cod_pre_dev"]),
         nil <- Repo.get_by(ItensSchema, filial_orig: params["filial_orig"]),
         nil <- Repo.get_by(ItensSchema, produto: params["produto"]),
         nil <- Repo.get_by(ItensSchema, quant: params["quant"]) do
          create(params)
    else
      itens ->
        {:ok, itens}
    end
  end
end
