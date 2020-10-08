defmodule Tecnovix.NotificacoesClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.NotificacoesClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.NotificacoesClienteSchema
  import Ecto.Query

  def confirmed_payment(pedido, cliente) do
    params_confirmed_payment(pedido, cliente)
    |> __MODULE__.create()
  end

  def params_confirmed_payment(pedido, cliente) do
    Map.new()
    |> Map.put("cliente_id", cliente.id)
    |> Map.put("titulo", "Pedido Confirmado")
    |> Map.put("descricao", "Pagamento confirmado e a previsão de entrega é para #{pedido.previsao_entrega}")
    |> Map.put("enviado", 1)
    |> Map.put("data", DateTime.truncate(DateTime.utc_now(), :second))
  end

  def get_notifications(cliente) do
    NotificacoesClienteSchema
    |> where([n], n.cliente_id == ^cliente.id)
    |> Repo.all()
  end
end
