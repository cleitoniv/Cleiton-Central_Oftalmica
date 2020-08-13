defmodule Tecnovix.Endpoints.ProtheusProd do
  @behaviour Tecnovix.Endpoints.Protheus
  alias Tecnovix.Endpoints.Protheus

  @header [{"Content-Type", "application/x-www-form-urlencoded"}]

  @impl true
  def token(%{username: _username, password: _password} = params) do
    params = Map.put(params, :grant_type, "password")
    url = Protheus.generate_url("/rest/api/oauth2/v1/token", params)
    HTTPoison.post(url, [], @header)
  end

  @impl true
  def get_by_cnpj_cpf(_params) do
  end

  @impl true
  def get_address_by_cep(_params) do
  end

  @impl true
  def get_delivery_prevision(_params) do
  end

  @impl true
  def get_product_by_serial(_params) do
  end

  @impl true
  def get_client_products(_params) do
  end

  @impl true
  def get_client_points(_params) do
  end

  @impl true
  def generate_boleto(_params) do
  end

  @impl true
  def refresh_token(%{refresh_token: _token} = params) do
    params = Map.put(params, :grant_type, "refresh_token")
    url = Protheus.generate_url("/rest/api/oauth2/v1/token", params)
    HTTPoison.post(url, [], @header)
  end

  @impl true
  def get_cliente(%{cnpj_cpf: cnpj_cpf, token: token}) do
    params = %{"A1_CGC" => cnpj_cpf}
    url = Protheus.generate_url("/rest/fwmodel/sa1rest", params)
    header = Protheus.authenticate(@header, token)
    HTTPoison.get(url, header)
  end
end
