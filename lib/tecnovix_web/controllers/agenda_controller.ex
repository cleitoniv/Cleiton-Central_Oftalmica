defmodule TecnovixWeb.AgendaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.AgendaModel
  alias Tecnovix.AgendaModel

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    {:ok, seller} = conn.private.auth

    params =
      Map.new()
      |> Map.put("cliente_id", params["id"])
      |> Map.put("temporizador", params["temporizador"])
      |> Map.put("date", params["date"])
      |> Map.put("vendedor_id", seller.id)
      |> Map.put("turno_manha", params["manha"])
      |> Map.put("turno_tarde", params["tarde"])

    case AgendaModel.create(params) do
      {:ok, schedule} ->
        conn
        |> put_status(200)
        |> put_resp_content_type("application/json")
        |> render("show.json", %{item: schedule})

      error ->
        error
    end
  end

  def get_all_schedules(conn, _params) do
    {:ok, seller} = conn.private.auth

    with {:ok, schedules} <- AgendaModel.get_all_schedules(seller.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("schedules.json", %{item: schedules})
    end
  end

  def get_schedule_by_seller(conn, _params) do
    {:ok, seller} = conn.private.auth

    with {:ok, schedule} <- AgendaModel.get_schedule_by_seller(seller.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: schedule})
    end
  end

  @spec get_citys(any, map) :: {:error, HTTPoison.Error.t()} | Plug.Conn.t()
  def get_citys(conn, _params) do
    {:ok, seller} = conn.private.auth

    with {:ok, ufs} <- AgendaModel.get_ufs(),
         {:ok, uf} <- AgendaModel.get_uf_by_region(seller.regiao, ufs),
         {:ok, resp} <- AgendaModel.get_citys(uf) do
      citys = Jason.decode!(resp.body)

      citys =
        Enum.reduce(citys, [], fn city, acc ->
          [city["nome"]] ++ acc
        end)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: citys}))
    end
  end
end
