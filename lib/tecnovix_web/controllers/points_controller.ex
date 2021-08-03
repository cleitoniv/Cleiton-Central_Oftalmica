defmodule TecnovixWeb.PointsController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PointsModel
  alias Tecnovix.PointsModel

  def add_points(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, info} <- PointsModel.create(params) do
      conn
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: info})
    end
  end
end
