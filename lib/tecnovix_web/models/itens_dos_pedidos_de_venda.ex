defmodule Tecnovix.ItensDosPedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDosPedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDosPedidosDeVendaSchema, as: ItensSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(ItensSchema, filial: params["filial"]),
         nil <- Repo.get_by(ItensSchema, num_pedido: params["num_pedido"]),
         nil <- Repo.get_by(ItensSchema, produto: params["produto"]),
         nil <- Repo.get_by(ItensSchema, quantidade: params["quantidade"]) do
          create(params)
    else
      itens ->
        {:ok, itens}
    end
  end
end
