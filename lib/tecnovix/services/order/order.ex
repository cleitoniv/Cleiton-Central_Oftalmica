defmodule Tecnovix.Services.Order do
  use GenServer
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.Repo
  import Ecto.Query

  # Legenda de Pedidos
  #
  # "S" -> Sim foi pago.
  # "N" -> Não foi pago.
  # "R" -> Reembolsado.
  # "P" -> Pendente de pagamento.

  def verify_pedidos(pedidos) do
    verify =
      Enum.map(pedidos, fn map ->
        {:ok, order_json} = Wirecard.get(map.order_id, :orders)
        order = Jason.decode!(order_json.body)

        case order["status"] do
          "PAID" ->
            PedidosDeVendaModel.update_order(map, "S")

          "NOT_PAID" ->
            PedidosDeVendaModel.update_order(map, "N")

          "REVERTED" ->
            PedidosDeVendaModel.update_order(map, "R")

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
      |> where([p], p.status_ped == 0 and p.pago == "P" and not is_nil(p.order_id))
      |> Repo.all()
      |> verify_pedidos()
      |> IO.inspect

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
end
