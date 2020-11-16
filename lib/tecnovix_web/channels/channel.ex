defmodule TecnovixWeb.Channel do
  use Phoenix.Channel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.App.Screens

  def check_cliente_id(id, id, socket) do
    {:ok, socket}
  end

  def check_cliente_id(_id, _cliente_id, _socket) do
    {:error, :unauthorized}
  end

  def join("cliente:" <> id, _payload, socket) do
    case socket.assigns.cliente do
      %ClientesSchema{} = cliente ->
        check_cliente_id(id, "#{cliente.id}", socket)

      %UsuariosClienteSchema{} = usuario ->
        check_cliente_id(id, "#{usuario.id}", socket)
    end
  end

  def handle_in("update_notifications_number", _payload, socket) do
    stub = Screens.stub()

    notifications = stub.get_notifications(socket.assigns.cliente)

    broadcast!(socket, "update_notifications_number", %{"notifications" => notifications})

    {:reply, :ok, socket}
  end
end
