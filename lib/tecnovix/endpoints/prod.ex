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
  def get_address_by_cep(_params) do
  end

  @impl true
  def get_delivery_prevision(_params) do
  end

  @impl true
  def get_product_by_serial(
        %{cliente: cliente, loja: loja, serial: serial, token: token} = params
      ) do
    header = Protheus.authenticate(@header, token)

    url =
      "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/SERREST/?CLIENTE=005087&LOJA=01&NUMSERIE=#{
        serial
      }"

    {:ok, product_serial} = HTTPoison.get(url, header)
  end

  @impl true
  def get_cliente(%{cnpj_cpf: "038" <> _cnpj}) do
    resp = Jason.encode!(Tecnovix.TestHelp.cliente_cnpj())

    {:ok, %{status_code: 200, body: resp}}
  end

  @impl true
  def get_cliente(%{cnpj_cpf: "037" <> _cpf}) do
    resp = Jason.encode!(Tecnovix.TestHelp.cliente())

    {:ok, %{status_code: 200, body: resp}}
  end

  @impl true
  def get_client_products(%{cliente: cliente, loja: loja, count: count, token: token}) do
    header = Protheus.authenticate(@header, token)

    url =
      "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/GRIDREST/?CLIENTE=#{"005087"}&LOJA=#{
        "011"
      }&COUNT=#{count}"

    {:ok, get} = HTTPoison.get(url, header)

    {:ok, Jason.decode!(get.body)}
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

  def organize_cliente(http) do
    cliente = Jason.decode!(http.body)

    organize =
      Enum.flat_map(cliente["resources"], fn resource ->
        Enum.flat_map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn field, acc ->
            case Map.has_key?(acc, field["id"]) do
              false ->
                case field["id"] == "A1_END" do
                  true ->
                    [endereco, num] = String.split(field["value"], [", ", ","])

                    Map.put(acc, field_crm_cnae(field), field["value"])
                    |> Map.put("A1_NUM", num)

                  false ->
                    Map.put(acc, field_crm_cnae(field), field["value"])
                end

              true ->
                acc
            end
          end)
        end)
      end)
      |> Map.new()

    {:ok, organize}
  end

  def field_crm_cnae(field) do
    case field["id"] do
      "A1_YCRM" -> "A1_YCRM_CNAE"
      "A1_CNAE" -> "A1_YCRM_CNAE"
      _ -> field["id"]
    end
  end
end
