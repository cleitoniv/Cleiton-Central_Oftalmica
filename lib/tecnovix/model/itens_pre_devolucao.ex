defmodule Tecnovix.ItensPreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensPreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensPreDevolucaoSchema, as: ItensSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn itens, multi ->
        with nil <- Repo.get_by(ItensSchema, filial: itens["filial"]),
             nil <- Repo.get_by(ItensSchema, cod_pre_dev: itens["cod_pre_dev"]),
             nil <- Repo.get_by(ItensSchema, filial_orig: itens["filial_orig"]),
             nil <- Repo.get_by(ItensSchema, produto: itens["produto"]),
             nil <- Repo.get_by(ItensSchema, quant: itens["quant"]) do
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
          "cod_pre_dev" => cod_pre_dev,
          "filial_orig" => filial_orig,
          "produto" => produto,
          "quant" => quant
        } = params
      ) do
    with nil <- Repo.get_by(ItensSchema, filial: filial),
         nil <- Repo.get_by(ItensSchema, cod_pre_dev: cod_pre_dev),
         nil <- Repo.get_by(ItensSchema, filial_orig: filial_orig),
         nil <- Repo.get_by(ItensSchema, produto: produto),
         nil <- Repo.get_by(ItensSchema, quant: quant) do
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
