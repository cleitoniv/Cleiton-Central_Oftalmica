defmodule Tecnovix.Services.OrderFinan do
  use GenServer
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.CreditoFinanceiroSchema
  alias Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.Repo
  import Ecto.Query

  @order_limit 100

  # Legenda de Pedidos
  #
  # "1" -> Sim foi pago.
  # "2" -> Não foi pago.

  def verify_pedidos(pedidos) do
    verify =
      Enum.map(pedidos, fn map ->
        with {:ok, %{status_code: 200} = order_json} <- Wirecard.get(map.wirecard_pedido_id, :orders) |> IO.inspect,
             order <- Jason.decode!(order_json.body) do
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
        else
          _ -> %{}
        end
      end)

    {:ok, verify}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :orderFinan)
  end

  def init(_) do
    Process.send(self(), {:ok, []}, [:noconnect])
    {:ok, []}
  end

  def handle_info({:ok, msg}, _state) do
    pedidos =
      CreditoFinanceiroSchema
      |> where([p], p.status == 0)
      |> limit(@order_limit)
      |> Repo.all()
      |> verify_pedidos()

    Process.send_after(self(), pedidos, 5000)
    {:noreply, msg}
  end
end
