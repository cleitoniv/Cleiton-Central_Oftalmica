defmodule TecnovixWeb.ProtheusController do
  use TecnovixWeb, :controller
  alias Tecnovix.Services.Auth
  alias Tecnovix.Endpoints.Protheus

  action_fallback Tecnovix.Resources.Fallback


  def get_cliente(conn, %{"cnpj_cpf" => cnpj_cpf}) do
    protheus = Protheus.stub()

    with {:ok, auth} <- Auth.token(),
         {:ok, response = %{status_code: 200}} <-
           protheus.get_cliente(%{cnpj_cpf: cnpj_cpf, token: auth["acess_token"]}) do
      body = Jason.decode!(response.body)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{status: "FOUND", data: body}))
    else
      _ ->
        {:error, :protheus_not_found}
    end
  end
end
