defmodule Tecnovix.ContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContratoDeParceriaSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
    Enum.reduce(params["data"], Multi.new(), fn contrato, multi ->
      with nil <- Repo.get_by(ContratoDeParceriaSchema, filial: contrato["filial"]),
           nil <- Repo.get_by(ContratoDeParceriaSchema, contrato_n: contrato["contrato_n"]) do
           multi
           |> Multi.insert(Ecto.UUID.autogenerate(), ContratoDeParceriaSchema.changeset(%ContratoDeParceriaSchema{}, contrato))
      else
       changeset ->
         multi
         |> Multi.update(Ecto.UUID.autogenerate(), ContratoDeParceriaSchema.changeset(changeset, contrato))
      end
    end)
    Repo.transaction(multi)
  end

  def insert_or_update(%{"filial" => filial, "contrato_n" => contrato_n} = params) do
    with nil <- Repo.get_by(ContratoDeParceriaSchema, filial: filial),
         nil <- Repo.get_by(ContratoDeParceriaSchema, contrato_n: contrato_n) do
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
