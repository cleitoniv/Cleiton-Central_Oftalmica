defmodule TecnovixWeb.ProtheusController do
  use TecnovixWeb, :controller
  alias Tecnovix.Services.Auth
  alias Tecnovix.Endpoints.Protheus

  action_fallback Tecnovix.Resources.Fallback

  def get_cliente(conn, %{"cnpj_cpf" => cnpj_cpf}) do
    protheus = Protheus.stub()

    with {:ok, auth} <- Auth.token(),
         {:ok, response = %{status_code: 200}} <-
           protheus.get_cliente(%{cnpj_cpf: cnpj_cpf, token: auth["access_token"]}),
         {:ok, cliente} <- protheus.organize_cliente(response) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, status: "FOUND", data: cliente}))
    else
      _ ->
        {:error, :protheus_not_found}
    end
  end

  def generate_boleto(conn, %{"valor" => valor}) do
    protheus = Protheus.stub()

    {:ok, cliente} = conn.private.auth

    with {:ok, auth} <- Auth.token(),
         {:ok, boleto = %{status_code: 200}} <- protheus.generate_boleto(auth["access_token"]),
         {:ok, resp} <- protheus.organize_boleto(boleto, valor) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: resp}))
    else
      {:ok, %{status_code: 401}} ->
        {:error, :not_authorized}

      v ->
        IO.inspect(v)
        {:error, :not_found}
    end
  end
end
