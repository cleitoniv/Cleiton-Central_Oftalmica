defmodule TecnovixWeb.RescuePointsController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.RescuePointsModel
  alias Tecnovix.RescuePointsModel, as: RescueModel
  alias Tecnovix.App.Screens

  def rescue_points(conn, %{"points" => points, "credit_finan" => credit_finan} = params) do
    stub = Screens.stub()

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
