defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.PedidosDeVendaSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn pedidos, multi ->
        with nil <- Repo.get_by(PedidosDeVendaSchema, filial: pedidos["filial"]),
             nil <- Repo.get_by(PedidosDeVendaSchema, numero: pedidos["numero"]) do
        multi
        |> Multi.insert(Ecto.UUID.autogenerate(), PedidosDeVendaSchema.changeset(%PedidosDeVendaSchema{}, pedidos))
        else
          changeset ->
          multi
          |> Multi.update(Ecto.UUID.autogenerate(), PedidosDeVendaSchema.changeset(changeset, pedidos))
        end
      end)
      Repo.transaction(multi)
  end

  def insert_or_update(%{"filial" => filial, "numero" => numero} = params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, filial: filial),
         nil <- Repo.get_by(PedidosDeVendaSchema, numero: numero) do
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
