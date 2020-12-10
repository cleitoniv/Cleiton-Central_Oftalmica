defmodule TecnovixWeb.CartaoCreditoClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.LogsClienteModel

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    {:ok, cliente} = verify_auth(conn.private.auth)
    {:ok, usuario} = usuario_auth(conn.private.auth_user)

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, _result} <- CartaoModel.get_cc(%{"cliente_id" => cliente.id}),
         {:ok, cartao} <- CartaoModel.primeiro_cartao(params, cliente.id),
         {:ok, detail_card} <- CartaoModel.detail_card(cartao, cliente),
         {:ok, card} <- CartaoModel.create(detail_card),
         {:ok, _logs} <-
           LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Cartão de crédito #{params["cartao_number"]} adicionado."
           ) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: card})
    else
      {:error, %Ecto.Changeset{}} = error -> error
      _ -> {:error, :card_not_created}
    end
  end

  def delete_card(conn, %{"id" => id}) do
    {:ok, cliente} = verify_auth(conn.private.auth)
    {:ok, usuario} = conn.private.auth_user

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    with {:ok, card} <- CartaoModel.delete_card(id, cliente),
         {:ok, _logs} <-
          LogsClienteModel.create(
            ip,
            usuario,
            cliente,
            "Cartão de crédito #{card["cartao_number"]} deletado."
          ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end

  def select_card(conn, %{"id" => id}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, cartao} <- CartaoModel.select_card(id, cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end

  defp usuario_auth(auth) do
    case auth do
      nil -> ""
      usuario -> usuario
    end
  end

  def verify_auth({:ok, cliente}) do
    case cliente do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(cliente, :cliente)
        {:ok, user.cliente}

      v ->
        {:ok, v}
    end
  end
end
