defmodule Tecnovix.NotificacoesClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.NotificacoesClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.NotificacoesClienteSchema
  alias Tecnovix.PedidosDeVendaSchema
  import Ecto.Query

  def lido(cliente_id, params) do
    case Repo.get_by(NotificacoesClienteSchema, cliente_id: cliente_id) do
      {:ok, notificao} -> __MODULE__.update(notificao, params)
      _ -> {:error, :not_found}
    end
  end

  def aguardando_pagamento_boleto(cliente_id, pedido_id) do
    query =
      from p in PedidosDeVendaSchema,
        where: p.id == ^pedido_id and p.status == 0 and p.client_id == ^cliente_id

    case Repo.all(query) do
      [] ->
        {:error, :not_found}

      pedido ->
        %{
          "pedido" => pedido,
          "mensagem" => "Estamos aguardando o pagamento do boleto referente ao pedido."
        }
    end
  end
end
