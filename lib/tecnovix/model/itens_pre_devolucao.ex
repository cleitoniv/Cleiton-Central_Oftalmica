defmodule Tecnovix.ItensPreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.ItensPreDevolucaoSchema
  alias Tecnovix.Repo

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn itens ->
       with nil <-
              Repo.get_by(ItensSchema,
                filial: itens["filial"],
                code_pre_dev: itens["cod_pre_dev"],
                filial_orig: itens["filial_orig"],
                produto: itens["produto"],
                quant: itens["quant"]
              ) do
         create(itens)
       else
         changeset ->
           __MODULE__.update(changeset, itens)
       end
     end)}
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
    with nil <-
           Repo.get_by(ItensSchema,
             filial: filial,
             cod_pre_dev: cod_pre_dev,
             filial_orig: filial_orig,
             produto: produto,
             quant: quant
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
