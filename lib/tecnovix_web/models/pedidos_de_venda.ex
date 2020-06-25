defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.PedidosDeVendaSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, filial: params["filial"]),
         nil <- Repo.get_by(PedidosDeVendaSchema, numero: params["numero"]) do
          create(params)
    else
      pedido ->
        {:ok, pedido}
    end
  end
end
