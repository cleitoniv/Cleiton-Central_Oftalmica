defmodule TecnovixWeb.ProtheusController do
  use TecnovixWeb, :controller
  alias Tecnovix.Services.Auth
  alias Tecnovix.Endpoints.Protheus

  action_fallback Tecnovix.Resources.Fallback

  def get_cliente(conn, %{"cnpj_cpf" => cnpj_cpf}) do
    protheus = Protheus.stub()

    with {:ok, auth} <- Auth.token(),
         {:ok, response = %{status_code: 200}} <-
           protheus.get_cliente(%{cnpj_cpf: cnpj_cpf, token: auth["access_token"]}) |> IO.inspect,
         {:ok, data} <- protheus.organize_cliente(response) |> IO.inspect do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, status: "FOUND", data: data}))
    else
      _ ->
        {:error, :protheus_not_found}
    end
  end
end
