defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema
  alias Tecnovix.Repo
  alias Tecnovix.PreDevolucaoSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn devolucao, multi ->
        with nil <- Repo.get_by(PreDevolucaoSchema, filial: devolucao["filial"]),
             nil <- Repo.get_by(PreDevolucaoSchema, cod_pre_dev: devolucao["cod_pre_dev"]) do
          multi
          |> Multi.insert(Ecto.UUID.autogenerate(), PreDevolucaoSchema.changeset(%PreDevolucaoSchema{}, devolucao))
        else
          changeset ->
          multi
          |> Multi.update(Ecto.UUID.autogenerate(), PreDevolucaoSchema.changeset(changeset, devolucao))
        end
      end)
      Repo.transaction(multi)
  end

  def insert_or_update(%{"filial" => filial, "cod_pre_dev" => cod_pre_dev} = params) do
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: filial),
         nil <- Repo.get_by(PreDevolucaoSchema, cod_pre_dev: cod_pre_dev) do
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
