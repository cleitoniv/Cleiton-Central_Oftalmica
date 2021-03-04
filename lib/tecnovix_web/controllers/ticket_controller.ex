defmodule TecnovixWeb.TicketController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.TicketModel
  alias Tecnovix.TicketModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, ticket} <- TicketModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: ticket})
    end
  end

  def create_ticket(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    params =
      Map.put(params, "email", cliente.email)
      |> Map.put("nome", cliente.nome)

    with {:ok, ticket} <- TicketModel.create(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: ticket})
    else
      {:ok, %{status_code: 401}} -> {:error, :not_authorized}
      _ -> {:error, :system_fail}
    end
  end

  def get_tickets(conn, _params) do
    with {:ok, tickets} <- TicketModel.get_tickets() do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("tickets.json", %{item: tickets})
    end
  end
end
