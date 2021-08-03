defmodule Tecnovix.TicketModel do
  use Tecnovix.DAO, schema: Tecnovix.TicketSchema
  import Ecto.Query
  alias Tecnovix.Repo
  alias Tecnovix.TicketSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn ticket ->
       with nil <- Repo.get(TicketSchema, ticket["id"]) do
         create(ticket)
       else
         changeset -> __MODULE__.update(changeset, ticket)
       end
     end)}
  end

  def insert_or_update(%{"id" => id} = params) do
    case Repo.get(TicketSchema, id) do
      nil ->
        create(params)

      changeset ->
        __MODULE__.update(changeset, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def get_tickets do
    tickets =
      TicketSchema
      |> where([t], t.status == 0)
      |> Repo.all()

    {:ok, tickets}
  end
end
