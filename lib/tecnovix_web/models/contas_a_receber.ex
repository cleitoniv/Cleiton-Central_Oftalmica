defmodule Tecnovix.ContasAReceberModel do
  use Tecnovix.DAO, schema: Tecnovix.ContasAReceberSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContasAReceberSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(ContasAReceberSchema, filial: params["filial"]),
         nil <- Repo.get_by(ContasAReceberSchema, no_titulo: params["no_titulo"]),
         nil <- Repo.get_by(ContasAReceberSchema, cliente: params["cliente"]),
         nil <- Repo.get_by(ContasAReceberSchema, loja: params["loja"]) do
          create(params)
    else
      contas ->
        {:ok, contas}
    end
  end
end
