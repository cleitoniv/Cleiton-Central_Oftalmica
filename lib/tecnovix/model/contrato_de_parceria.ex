defmodule Tecnovix.ContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContratoDeParceriaSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(params["data"], %{}, fn contrato, _acc ->
      with nil <-
             Repo.get_by(ContratoDeParceriaSchema,
               filial: contrato["filial"],
               contrato_n: contrato["contrato_n"]
             ) do
        create(contrato)
      else
        changeset ->
          Repo.preload(changeset, :items)
          |> __MODULE__.update(contrato)
      end
    end)
  end

  def insert_or_update(%{"filial" => filial, "contrato_n" => contrato_n} = params) do
    with nil <- Repo.get_by(ContratoDeParceriaSchema, filial: filial, contrato_n: contrato_n) do
      __MODULE__.create(params)
    else
      contrato ->
        {:ok, contrato}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
