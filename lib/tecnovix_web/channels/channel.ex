defmodule TecnovixWeb.Channel do
  use Phoenix.Channel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  def check_cliente_id(id, id, socket) do
    {:ok, socket}
  end

  def check_cliente_id(_id, _cliente_id, _socket) do
    {:error, :not_authorized}
  end

  def join("cliente:" <> id, _payload, socket) do
    case socket.assigns.cliente do
      %ClientesSchema{} = cliente ->
        check_cliente_id(id, "#{cliente.id}", socket)

      %UsuariosClienteSchema{} = usuario ->
        check_cliente_id(id, "#{usuario.id}", socket)
    end
  end

  def handle_in("update_money", _payload, socket) do
    money = Tecnovix.CreditoFinanceiroModel.sum_credits(socket.assigns.cliente) - Tecnovix.PedidosDeVendaModel.sum_credits((socket.assigns.cliente))

    broadcast!(socket, "update_money", %{"money" => money})

    {:reply, :ok, socket}
  end
end
