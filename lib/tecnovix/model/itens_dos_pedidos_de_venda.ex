defmodule Tecnovix.ItensDosPedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDosPedidosDeVendaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDosPedidosDeVendaSchema, as: ItensSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn itens, multi ->
      with nil <- Repo.get_by(ItensSchema, filial: itens["filial"]),
           nil <- Repo.get_by(ItensSchema, num_pedido: itens["num_pedido"]),
           nil <- Repo.get_by(ItensSchema, produto: itens["produto"]),
           nil <- Repo.get_by(ItensSchema, quantidade: itens["quantidade"]) do
      multi
      |> Multi.insert(Ecto.UUID.autogenerate(), ItensSchema.changeset(%ItensSchema{}, itens))
      else
      changeset ->
        multi
        |> Multi.update(Ecto.UUID.autogenerate(), ItensSchema.changeset(changeset, itens))
      end
    end)
    Repo.transaction(multi)
  end

  def insert_or_update(
        %{
          "filial" => filial,
          "num_pedido" => num_pedido,
          "produto" => produto,
          "quantidade" => quantidade
        } = params
      ) do
    with nil <- Repo.get_by(ItensSchema, filial: filial),
         nil <- Repo.get_by(ItensSchema, num_pedido: num_pedido),
         nil <- Repo.get_by(ItensSchema, produto: produto),
         nil <- Repo.get_by(ItensSchema, quantidade: quantidade) do
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
