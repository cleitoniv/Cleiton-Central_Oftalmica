defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.ClientesModel
  alias Tecnovix.Repo
  alias Tecnovix.PedidosDeVendaSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn pedidos ->
       with nil <-
              Repo.get_by(PedidosDeVendaSchema,
                filial: pedidos["filial"],
                numero: pedidos["numero"]
              ) do
         create(pedidos)
       else
         changeset ->
           Repo.preload(changeset, :items)
           |> __MODULE__.update(pedidos)
       end
     end)}
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

  # def insert_app(%{"pedidos" => pedidos, "payment" => payment}) do
  #     with {:ok, pedidos_params} <- __MODULE__.pedido_params(pedidos, payment) do
  #
  #     end
  # end
  #
  # def pedido_params(pedidos, payment) do
  #   %{
  #     "filial" => pedidos["filial"],
  #     "numero" => pedidos["numero"],
  #     "cliente" => pedidos["cliente"],
  #     "tipo_venda" => pedidos["tipo_venda"]
  #
  #   }
  # end
end
