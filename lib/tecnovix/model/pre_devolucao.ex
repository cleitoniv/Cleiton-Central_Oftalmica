defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.PreDevolucaoSchema
  alias Tecnovix.ContratoDeParceriaSchema, as: Contrato

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn devolucao ->
       with nil <-
              Repo.get_by(PreDevolucaoSchema,
                filial: devolucao["filial"],
                cod_pre_dev: devolucao["cod_pre_dev"]
              ) do
         create(devolucao)
       else
         changeset ->
           Repo.preload(changeset, :items)
           |> __MODULE__.update(devolucao)
       end
     end)}
  end

  def insert_or_update(%{"filial" => filial, "cod_pre_dev" => cod_pre_dev} = params) do
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: filial, cod_pre_dev: cod_pre_dev) do
      __MODULE__.create(params)
    else
      devolucao ->
        {:ok, devolucao}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  #PRECISA TESTAR A DEVOLUCAO DE TROCA
  def create(cliente, params) do
    devolucao=
    cliente
    |> pre_devolucao(params)
    |> itens_pre_devolucao(cliente)

    %PreDevolucaoSchema{}
    |> PreDevolucaoSchema.changeset(devolucao)
    |> IO.inspect
    |> Repo.insert()
  end

  def pre_devolucao(cliente, params) do
    params
    |> Map.put("cliente_id", cliente.id)
    |> Map.put("filial", params["filial"])
    |> Map.put("cod_pre_dev", String.slice(Ecto.UUID.autogenerate(), 0..5))
    |> Map.put("loja", cliente.loja)
    |> Map.put("cliente", cliente.codigo)
  end

  def itens_pre_devolucao(params, cliente) do

    params
    |> Map.put("filial", params["filial"])
    |> Map.put("cod_pre_dev", params["cod_pre_dev"])
  end

  def get_contrato(cliente) do
    case Repo.get_by(Contrato, cliente_id: cliente.id) do
      nil -> {:error, :not_found}
      contrato -> {:ok, contrato}
    end
  end
end
