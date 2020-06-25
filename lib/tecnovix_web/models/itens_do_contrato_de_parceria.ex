defmodule Tecnovix.ItensDoContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDoContratoParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDoContratoParceriaSchema, as: ItensSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(ItensSchema, filial: params["filial"]),
         nil <- Repo.get_by(ItensSchema, contrato_n: params["contrato_n"]),
         nil <- Repo.get_by(ItensSchema, item: params["item"]),
         nil <- Repo.get_by(ItensSchema, produto: params["produto"]),
         nil <- Repo.get_by(ItensSchema, cliente: params["cliente"]),
         nil <- Repo.get_by(ItensSchema, loja: params["loja"]) do
          create(params)
    else
      itens_contrato ->
        {:ok, itens_contrato}
    end
  end
end
