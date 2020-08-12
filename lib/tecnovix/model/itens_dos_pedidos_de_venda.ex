defmodule Tecnovix.ItensDosPedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDosPedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDosPedidosDeVendaSchema, as: ItensSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(params["data"], %{}, fn itens, _acc ->
      with nil <-
             Repo.get_by(ItensSchema,
               filial: itens["filial"],
               num_pedido: itens["num_pedido"],
               produto: itens["produto"],
               quantidade: itens["quantidade"]
             ) do
        create(itens)
      else
        changeset ->
          __MODULE__.update(changeset, itens)
      end
    end)
  end

  def insert_or_update(
        %{
          "filial" => filial,
          "num_pedido" => num_pedido,
          "produto" => produto,
          "quantidade" => quantidade
        } = params
      ) do
    with nil <-
           Repo.get_by(ItensSchema,
             filial: filial,
             num_pedido: num_pedido,
             produto: produto,
             quantidade: quantidade
           ) do
      __MODULE__.create(params)
    else
      itens ->
        {:ok, itens}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
