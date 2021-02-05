defmodule Tecnovix.Services.OrderFinan do
  use GenServer
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.CreditoFinanceiroSchema
  alias Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.Repo
  import Ecto.Query

  # Legenda de Pedidos
  #
  # "1" -> Sim foi pago.
  # "2" -> Não foi pago.

  def verify_pedidos(pedidos) do
    verify =
      Enum.map(pedidos, fn map ->
        {:ok, order_json} = Wirecard.get(map.wirecard_pedido_id, :orders)
        order = Jason.decode!(order_json.body)

        case order["status"] do
          "PAID" ->
            CreditoFinanceiroModel.insert_or_update(%{
              "id" => map.id,
              "status" => 1,
              "saldo" => map.valor
            })

          "NOT_PAID" ->
            CreditoFinanceiroModel.insert_or_update(%{"id" => map.id, "status" => 2})

          # "REVERTED" ->
          #   CreditoFinanceiroModel.insert_or_update(map)

          _ ->
            []
        end
      end)

    {:ok, verify}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :orderFinan)
  end

  def init(_) do
    pedidos =
      CreditoFinanceiroSchema
      |> where([p], p.status == 0)
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
end
