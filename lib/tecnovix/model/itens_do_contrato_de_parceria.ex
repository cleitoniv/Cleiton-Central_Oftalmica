defmodule Tecnovix.ItensDoContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDoContratoParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDoContratoParceriaSchema, as: ItensSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn itens, multi ->
        with nil <- Repo.get_by(ItensSchema, filial: itens["filial"]),
             nil <- Repo.get_by(ItensSchema, contrato_n: itens["contrato_n)"]),
             nil <- Repo.get_by(ItensSchema, item: itens["item"]),
             nil <- Repo.get_by(ItensSchema, produto: itens["produto"]),
             nil <- Repo.get_by(ItensSchema, cliente: itens["cliente"]),
             nil <- Repo.get_by(ItensSchema, loja: itens["loja"]) do
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
          "contrato_n" => contrato_n,
          "item" => item,
          "produto" => produto,
          "cliente" => cliente,
          "loja" => loja
        } = params
      ) do
    with nil <- Repo.get_by(ItensSchema, filial: filial),
         nil <- Repo.get_by(ItensSchema, contrato_n: contrato_n),
         nil <- Repo.get_by(ItensSchema, item: item),
         nil <- Repo.get_by(ItensSchema, produto: produto),
         nil <- Repo.get_by(ItensSchema, cliente: cliente),
         nil <- Repo.get_by(ItensSchema, loja: loja) do
      __MODULE__.create(params)
    else
      itens_contrato ->
        {:ok, itens_contrato}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
