defmodule Tecnovix.Services.Order do
  use GenServer
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.Repo
  import Ecto.Query

  def verify_pedidos(pedidos) do
    verify =
      Enum.map(pedidos, fn map ->
        {:ok, order_encode} = Wirecard.get(map.order_id, :orders)
        order = Jason.decode!(order_encode.body)

        case order["status"] do
          "PAID" ->
            PedidosDeVendaModel.update_order(map)
          _ ->
            []
        end
      end)

    {:ok, verify}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :order)
  end

  def init(_) do
    pedidos =
      PedidosDeVendaSchema
      |> where([p], p.status_ped == 0)
      |> Repo.all()
      |> verify_pedidos()

    with {:ok, state} = resp <- pedidos do
      Process.send_after(self(), {:ok, state}, 5000)
      resp
    else
      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_info({:ok, msg}, state) do
    Process.send_after(self(), {:ok, state}, 5000)
    {:noreply, msg}
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def get_msg() do
    GenServer.call(:order, :get)
  end
end
