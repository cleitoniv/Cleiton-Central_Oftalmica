defmodule TecnovixWeb.AtendPrefClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.AtendPrefClienteModel
  alias Tecnovix.AtendPrefClienteModel
  alias Tecnovix.LogsClienteModel

  action_fallback Tecnovix.Resources.Fallback

  def get_by_cod_cliente(conn, %{"cod_cliente" => cod_cliente}) do
    with {:ok, atend_pref} <- AtendPrefClienteModel.get_by(cod_cliente: cod_cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: atend_pref})
    end
  end

  def insert_or_update(conn, params) do
    with {:ok, atend_pref} <- AtendPrefClienteModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("atends.json", %{item: atend_pref})
    end
  end

  def get_and_crud_atendimento(conn, %{"horario" => horario} = params) do
    {:ok, cliente} = conn.private.auth
    {:ok, usuario} = conn.private.auth_user

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, atendimento} <- AtendPrefClienteModel.formatting_atend(params, cliente),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Horario de atendimento adicionado/atualizado para #{cliente.dia_remessa}-#{horario}"
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: atendimento})
    end
  end
end
