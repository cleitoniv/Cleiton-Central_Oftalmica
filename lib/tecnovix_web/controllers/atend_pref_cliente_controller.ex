defmodule TecnovixWeb.AtendPrefClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.AtendPrefClienteModel
  alias Tecnovix.AtendPrefClienteModel
  alias Tecnovix.LogsClienteModel

  def insert_or_update(conn, params) do
    with {:ok, _atend_pref} <- AtendPrefClienteModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end

  def atend_pref(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, atendimento} <- AtendPrefClienteModel.create(params, cliente.id) do
      case conn.private.auth do
        {:ok, %Tecnovix.ClientesSchema{}} ->
          LogsClienteModel.create(%{
            "cliente_id" => cliente.id,
            "data" => DateTime.utc_now(),
            "ip" => "teste",
            "dispositivo" => "teste",
            "acao_realizada" => "Atendimento preferencial do cliente atualizado"
          })

        {:ok, %Tecnovix.UsuariosClienteSchema{} = params} ->
          LogsClienteModel.create(%{
            "cliente_id" => params.cliente_id,
            "usuario_cliente_id" => params.id,
            "data" => DateTime.utc_now(),
            "ip" => "teste",
            "dispositivo" => "teste",
            "acao_realizada" => "Atendimento preferencial do cliente atualizado"
          })
      end

      conn
      |> put_status(:created)
      |> put_resp_content_type("applicaton/json")
      |> put_view(TecnovixWeb.AtendPrefClienteView)
      |> render("show.json", %{item: atendimento})
    end
  end
end
