defmodule Tecnovix.ItensDoContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensDoContratoParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ItensDoContratoParceriaSchema, as: ItensSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(data, %{}, fn itens, _acc ->
      with nil <-
             Repo.get_by(ItensSchema,
               filial: itens["filial"],
               contrato_n: itens["contrato_n"],
               item: itens["item"],
               produto: itens["produto"],
               cliente: itens["cliente"],
               loja: itens["loja"]
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
          "contrato_n" => contrato_n,
          "item" => item,
          "produto" => produto,
          "cliente" => cliente,
          "loja" => loja
        } = params
      ) do
    with nil <-
           Repo.get_by(ItensSchema,
             filial: filial,
             contrato_n: contrato_n,
             item: item,
             produto: produto,
             cliente: cliente,
             loja: loja
           ) do
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
