defmodule TecnovixWeb.RescuePointsController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.RescuePointsModel
  alias Tecnovix.RescuePointsModel, as: RescueModel

  def rescue_points(conn, %{"points" => _points, "credit_finan" => _credit_finan} = params) do
    {:ok, cliente} = conn.private.auth
    params = Map.put(params, "cliente_id", cliente.id)

    with {:ok, rescue_points} <- RescueModel.create(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: rescue_points})
    end
  end
end
