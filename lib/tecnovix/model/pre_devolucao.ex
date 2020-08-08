defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.PreDevolucaoSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(params["data"], %{}, fn devolucao, _acc ->
      with nil <-
             Repo.get_by(PreDevolucaoSchema,
               filial: devolucao["filial"],
               cod_pre_dev: devolucao["cod_pre_dev"]
             ) do
        create(params)
      else
        changeset ->
          __MODULE__.update(changeset, devolucao)
      end
    end)
  end

  def insert_or_update(%{"filial" => filial, "cod_pre_dev" => cod_pre_dev} = params) do
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: filial, code_pre_dev: cod_pre_dev) do
      __MODULE__.create(params)
    else
      devolucao ->
        {:ok, devolucao}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
