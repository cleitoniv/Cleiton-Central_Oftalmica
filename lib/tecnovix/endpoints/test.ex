defmodule Tecnovix.Endpoints.ProtheusTest do
  @behaviour Tecnovix.Endpoints.Protheus
  alias Tecnovix.Endpoints.Protheus
  alias Tecnovix.TestHelp

  @header [{"Content-Type", "application/x-www-form-urlencoded"}]

  @impl true
  def token(_params) do
    resp =
      Jason.encode!(%{
        "access_token" =>
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6IlRFQ05PVklYIiwiaWF0IjoxNTk3MjYwNTA0LCJ1c2VyaWQiOiIwMDAxMTQiLCJleHAiOjE1OTcyNjQxMDR9.6ni2m9MUyYEYkStQe56aQzZBAZbXQJvIB+08zosmhCE=",
        "refresh_token" =>
          "A0YbiO0RLVis8if0YXPwZnOa.GFcY-fcAWT-xziu-c3GRB26IOc7IUGVbPp-bVvcLdOnrujegcNiSzIAddkulPxBeLRqb17UOZ2mMsUwMAkvZyHLHxllqYHZ6UI1IKJHGsurYHO81No4egKlnPQ==.1orFb2GA3kREkBjhQSG3dF3ug3C/DZFTnIns357umzg=",
        "scope" => "default",
        "token_type" => "Bearer",
        "expires_in" => 3600
      })

    {:ok, %{status_code: 201, body: resp}}
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
  def generate_boleto(_params) do
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
