defmodule Tecnovix.NotificacoesClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.NotificacoesClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.NotificacoesClienteSchema
  import Ecto.Query

  def read_notification(notification_id, cliente) do
    notification =
      NotificacoesClienteSchema
      |> where([n], ^cliente.id == n.cliente_id and n.lido == false and ^notification_id == n.id)
      |> update([n], set: [lido: true])
      |> Repo.update_all([])
      |> IO.inspect
      
    {:ok, notification}
  end

  def get_notifications(cliente) do
    NotificacoesClienteSchema
    |> where([n], n.cliente_id == ^cliente.id)
    |> Repo.all()
  end

  def params_notifications(cliente, titulo, descricao) do
    Map.new()
    |> Map.put("cliente_id", cliente.id)
    |> Map.put("titulo", titulo)
    |> Map.put("descricao", descricao)
    |> Map.put("enviado", 1)
    |> Map.put("data", DateTime.truncate(DateTime.utc_now(), :second))
  end

  def confirmed_payment(pedido, cliente) do
    titulo = "Pedido Confirmado"
    descricao = "Pagamento confirmado e a previsão de entrega é para #{pedido.previsao_entrega}."

    params_notifications(cliente, titulo, descricao)
    |> __MODULE__.create()
  end

  def credit_finan_adquired(_credit, cliente) do
    titulo = "Crédito Financeiro Adquirido"
    descricao = "Confirmamos a sua compra de Créditos Financeiros para sua conta."

    params_notifications(cliente, titulo, descricao)
    |> __MODULE__.create()
  end

  def credit_product_adquired(_product, cliente) do
    titulo = "Crédito de Produto Adquirido"
    descricao = "Confirmamos a sua compra de Créditos de Produtos para sua conta."

    params_notifications(cliente, titulo, descricao)
    |> __MODULE__.create()
  end

  def effective_devolution(_devolution, cliente) do
    titulo = "Efetivação de Devolução"
    descricao = "Sua solicitação de devolução em crédito ou troca foi analisada por nossa equipe."

    params_notifications(cliente, titulo, descricao)
    |> __MODULE__.create()
  end

  def solicitation_devolution(_devolution, cliente) do
    titulo = "Solicitação de Devolução"
    descricao = "Recebemos sua solicitação de devolução em crédito ou troca, iremos analisá-la."

    params_notifications(cliente, titulo, descricao)
    |> __MODULE__.create()
  end
end
