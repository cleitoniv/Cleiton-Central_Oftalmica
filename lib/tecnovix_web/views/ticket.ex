defmodule TecnovixWeb.TicketView do
  use Tecnovix.Resource.View, model: Tecnovix.TicketModel

  def build(%{item: item}) do
    %{
      id: item.id,
      nome: item.nome,
      email: item.email,
      status: item.status,
      descricao: item.descricao,
      categoria: item.categoria
    }
  end

  def render("tickets.json", %{item: tickets}) do
    %{
      data: render_many(tickets, __MODULE__, "ticket.json", as: :item),
      success: true
    }
  end

  def render("ticket.json", %{item: item}) do
    %{
      id: item.id,
      nome: item.nome,
      email: item.email,
      status: item.status,
      descricao: item.descricao,
      categoria: item.categoria
    }
  end
end
