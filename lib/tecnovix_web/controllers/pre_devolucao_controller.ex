defmodule TecnovixWeb.PreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PreDevolucaoModel

  alias Tecnovix.{
    PreDevolucaoModel,
    NotificacoesClienteModel,
    CreditoFinanceiroModel,
    ClientesSchema,
    UsuariosClienteSchema,
    LogsClienteModel
  }

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, devolucao} <- PreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("devolucao.json", %{item: devolucao})
    end
  end

  defp usuario_auth(auth) do
    case auth do
      nil -> ""
      usuario -> usuario
    end
  end

  def create(conn, %{"param" => params}) do
    {:ok, usuario} = usuario_auth(conn.private.auth_user)

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          CreditoFinanceiroModel.get_cliente_by_id(usuario.cliente_id)
      end

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, devolucoes} <- PreDevolucaoModel.create(cliente, params),
         {:ok, _notifications} <-
           NotificacoesClienteModel.solicitation_devolution(devolucoes, cliente),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Devolução id #{devolucoes.id} criada com sucesso."
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("devolucoes.json", %{item: devolucoes})
    else
      _ ->
        {:error, :not_created}
    end
  end

  def get_devolucoes(conn, %{"filtro" => filtro}) do
    with {:ok, dev} <- PreDevolucaoModel.get_devolucoes(filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("devolucoes.json", %{item: dev})
    end
  end
end
