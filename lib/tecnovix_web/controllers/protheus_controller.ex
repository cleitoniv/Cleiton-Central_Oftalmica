defmodule TecnovixWeb.ProtheusController do
  use TecnovixWeb, :controller
  alias Tecnovix.Services.Auth
  alias Tecnovix.Endpoints.Protheus

  action_fallback Tecnovix.Resources.Fallback

  def get_cliente(conn, %{"cnpj_cpf" => cnpj_cpf}) do
    protheus = Protheus.stub()

    with {:ok, auth} <- Auth.token(),
         {:ok, response = %{status_code: 200}} <-
           protheus.get_cliente(%{cnpj_cpf: cnpj_cpf, token: auth["acess_token"]}),
         {:ok, data} <- protheus.organize_cliente(response) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, status: "FOUND", data: data}))
    else
      _ ->
        {:error, :protheus_not_found}
    end
  end

  def get_product(conn, _params) do
    protheus = Protheus.stub()

    {:ok, cliente} = conn.private.auth

    with {:ok, resp} <- protheus.get_client_products(cliente) do
      resp = Jason.decode!(resp)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: resp}))
    end
  end
end
