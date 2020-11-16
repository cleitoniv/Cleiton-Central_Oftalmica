defmodule Tecnovix.PointsModel do
  use Tecnovix.DAO, schema: Tecnovix.PointsSchema
  alias Tecnovix.PointsSchema
  alias Tecnovix.Repo

  def create(params) do
    params = Map.put(params, "dt_nas_pac", formatting_date(params["dt_nas_pac"]))

    %PointsSchema{}
    |> PointsSchema.changeset(params)
    |> Repo.insert()
  end

  def formatting_date(date) do
    [data] = String.split(date)

    [dia, mes, ano] =
      String.replace(date, "/", "-")
      |> String.split(~r{-})

    "#{ano}-#{mes}-#{dia}"
  end
end
