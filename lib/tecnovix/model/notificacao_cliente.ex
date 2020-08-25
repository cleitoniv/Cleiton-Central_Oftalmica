defmodule Tecnovix.NotificacoesClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.NotificacoesClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.NotificacoesClienteSchema
  import Ecto.Query

  def lido(cliente_id, params) do
    case Repo.get_by(NotificacoesClienteSchema, cliente_id: cliente_id) do
      {:ok, notificao} -> __MODULE__.update(notificao, params)
      _ -> {:error, :not_found}
    end
  end
end
