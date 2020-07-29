defmodule Tecnovix.AtendPrefClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.AtendPrefClienteSchema

  def create(params, cliente_id) do
    case __MODULE__.get_by(cliente_id: cliente_id) do
      nil -> __MODULE__.create(params)
      atend_pref -> __MODULE__.update(atend_pref, params)
    end
  end

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
