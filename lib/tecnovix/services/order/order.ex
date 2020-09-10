# defmodule Tecnovix.Services.Order do
#   use GenServer
#   alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
#   alias Tecnovix.PedidosDeVendaSchema
#   alias Tecnovix.PedidosDeVendaModel
#   alias Tecnovix.Repo
#   import Ecto.Query
#
#   def verify_pedidos(pedidos) do
#     Enum.map(pedidos, fn map ->
#       order_encode = Wirecard.get(map.order_id, :orders)
#       order = Jason.decode!(order_encode.body)
#
#       case order["status"] do
#         "NO_PAID" -> {:error, map}
#         "PAID" ->
#           PedidosDeVendaModel.update(map, Map.put(map, :status, 1))
#       end
#     end)
#   end
#
#   def start_link(_) do
#     GenServer.start_link(__MODULE__, :state, name: :order)
#   end
#
#   def init(_) do
#     pedidos =
#       PedidosDeVendaSchema
#       |> where([p], p.status_ped == 0)
#       |> Repo.all()
#       |> verify_pedidos()
#
#       with {:ok, state} = resp <- pedidos do
#         Process.send_after(self(), {:ok, state}, 60000)
#         resp
#       else
#         reason -> {:stop, reason}
#       end
#   end
#
#   def handle_info({:ok, msg}, state) do
#     Process.send_after(self(), {:ok, state}, 60000)
#     {:noreply, state}
#   end
#
#   def handle_cast(:verify_order, state) do
#     {:noreply, state}
#   end
#
#   def get_order() do
#     GenServer.cast(:order, :verify_order)
#   end
# end
