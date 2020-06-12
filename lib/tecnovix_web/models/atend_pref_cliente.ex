defmodule Tecnovix.AtendPrefClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.AtendPrefClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.AtendPrefClienteSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(AtendPrefClienteSchema, cod_cliente: params["cod_cliente"]),
         nil <- Repo.get_by(AtendPrefClienteSchema, loja_cliente: params["loja_cliente"]) do
          create(params)
    else
      cliente ->
        {:ok, cliente}
    end
  end
end
