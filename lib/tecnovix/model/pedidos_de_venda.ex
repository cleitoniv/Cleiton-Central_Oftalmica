defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.PedidosDeVendaSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(params["data"], %{}, fn pedidos, _acc ->
      with nil <-
             Repo.get_by(PedidosDeVendaSchema,
               filial: pedidos["filial"],
               numero: pedidos["numero"]
             ) do
        create(pedidos)
      else
        changeset ->
          __MODULE__.update(changeset, pedidos)
      end
    end)
  end

  def insert_or_update(%{"filial" => filial, "numero" => numero} = params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, filial: filial, numero: numero) do
      __MODULE__.create(params)
    else
      pedido ->
        {:ok, pedido}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
