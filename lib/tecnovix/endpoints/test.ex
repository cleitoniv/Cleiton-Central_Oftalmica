defmodule Tecnovix.Endpoints.ProtheusTest do
  @behaviour Tecnovix.Endpoints.Protheus
  alias Tecnovix.Endpoints.Protheus
  alias Tecnovix.TestHelp

  @header [{"Content-Type", "application/x-www-form-urlencoded"}]

  @impl true
  def token(params) do
    params = Map.put(params, :grant_type, "password")
    url = Protheus.generate_url("/rest/api/oauth2/v1/token", params)
    HTTPoison.post(url, [], @header)
  end

  @impl true
  def refresh_token(_params) do
    resp =
      Jason.encode!(%{
        "access_token" =>
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6IlRFQ05PVklYIiwiaWF0IjoxNTk2NDU3NDQwLCJ1c2VyaWQiOiIwMDAxMTQiLCJleHAiOjE1OTY0NjEwNDB9.LpCMk6u/r1Ntc+s9ynuCJR+wYo1pk2gp+zOtioQWHaY=",
        "refresh_token" =>
          "A0YbiO0BNViv4iuzYnPwZnOa.GFcY-fcAWT-xziu-c3GRB26IOc7IUGVbPp-bRvMLdOnrugmKOtuS3MgPQkbbCR97LTSbmrUOa2CdoVl/Gl63yEzHy1pqVntoZIAnIYPXqv7zHP8xcZ8J.3aSHXLmwRGCR9076g6eN7kItmQLHlJRE-a-DlR2W2y4=",
        "scope" => "default",
        "token_type" => "Bearer",
        "expires_in" => 3600
      })

    {:ok, %{status_code: 201, body: resp}}
  end

  @impl true
  def get_cliente(%{cnpj_cpf: "036012857201"}) do
    {:ok,
     %{
       status_code: 404,
       body: Jason.encode!(%{errorCode: 404, errorMessage: "Cliente nao encontrado!"})
     }}
  end

  @impl true
  def get_cliente(%{cnpj_cpf: cnpj_cpf, token: token}) do
    params = %{"A1_CGC" => cnpj_cpf}
    url = Protheus.generate_url("/rest/fwmodel/sa1rest", params)
    header = Protheus.authenticate(@header, token)
    HTTPoison.get(url, header)
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
  def get_client_products(%{cliente: _cliente, loja: _loja, count: _count, token: _token}) do
    resp =
      Jason.encode!(TestHelp.product_client())
      |> Jason.decode!()

    {:ok, resp}
  end

  @impl true
  def get_client_points(_params) do
  end

  @impl true
  def generate_boleto(token) do
    header = Protheus.authenticate(@header, token)

    url = "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/SE4REST"

    HTTPoison.get(url, header)
  end

  defp string_to_integer(string) do
    string
    |> String.replace("X", "")
    |> String.to_integer()
  end

  def organize_boleto(boleto, valor) do
    valor = String.to_integer(valor)

    boleto = Jason.decode!(boleto.body)

    organize_boleto =
      Enum.flat_map(boleto["resources"], fn resources ->
        Enum.flat_map(resources["models"], fn models ->
          Enum.map(models["fields"], fn field ->
            case field["id"] do
              "E4_CODIGO" -> %{"parcela" => "#{string_to_integer(field["value"])}x de #{(valor / 100) / string_to_integer(field["value"]) |> Float.ceil(2)}"}
              _ -> %{}
            end
          end)
        end)
      end)
      |> Enum.filter(fn map -> map != %{} end)
      |> Enum.map(fn map ->
        [antes, depois] = String.split(map["parcela"], ".")
        case String.length(depois) < 2 do
          true -> %{"parcela" => map["parcela"] <> "0"}
          false -> %{"parcela" => map["parcela"]}
        end
      end)

    {:ok, organize_boleto}
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
