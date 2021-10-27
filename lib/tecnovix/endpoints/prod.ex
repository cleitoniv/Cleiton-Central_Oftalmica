defmodule Tecnovix.Endpoints.ProtheusProd do
  @behaviour Tecnovix.Endpoints.Protheus
  alias Tecnovix.Endpoints.Protheus

  @header [{"Content-Type", "application/x-www-form-urlencoded"}]

  @impl true
  def token(%{username: _username, password: _password} = params) do
    params = Map.put(params, :grant_type, "password")

    url = Protheus.generate_url("/rest/api/oauth2/v1/token", params)

    IO.inspect(url)
    HTTPoison.post(url, [], @header)
  end

  @impl true
  def get_contract_table(%{cliente: cliente, loja: loja, grupo: grupo}, token) do
    url =
      Protheus.generate_url(
        "/rest/fwmodel/TBPRREST/?CLIENTE=#{cliente}&LOJA=#{loja}&GRUPO=#{grupo}"
      )

    # url =
    #   "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/TBPRREST/?CLIENTE=#{cliente}&LOJA=#{
    #     loja
    #   }&GRUPO=#{grupo}"

    header = Protheus.authenticate(@header, token)

    HTTPoison.get(url, header)
  end

  @impl true
  def get_contract_table_finan(%{cliente: cliente, loja: loja}, token) do
    url =
      Protheus.generate_url("/rest/fwmodel/TBPRREST/?CLIENTE=#{cliente}&LOJA=#{loja}&GRUPO=CRFI")

    # url =
    #   "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/TBPRREST/?CLIENTE=#{cliente}&LOJA=#{
    #     loja
    #   }&GRUPO=CRFI"

    header = Protheus.authenticate(@header, token)

    HTTPoison.get(url, header)
  end

  @impl true
  def get_product_by_serial(%{cliente: cliente, loja: loja, serial: serial, token: token}) do
    header = Protheus.authenticate(@header, token)

    url =
      Protheus.generate_url(
        "/rest/fwmodel/SERREST/?CLIENTE=#{cliente}&LOJA=#{loja}&NUMSERIE=#{serial}"
      )

    # url =
    #   "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/SERREST/?CLIENTE=#{cliente}&LOJA=#{
    #     loja
    #   }&NUMSERIE=#{serial}"

    HTTPoison.get(url, header)
  end

  @impl true
  def get_client_products(%{cliente: cliente, loja: loja, count: count, token: token}) do
    header = Protheus.authenticate(@header, token)

    url =
      Protheus.generate_url(
        "/rest/fwmodel/GRIDREST/?CLIENTE=#{cliente}&LOJA=#{loja}&COUNT=#{count}"
      )

    # url =
    #   "http://hom.app.centraloftalmica.com:8080/rest/fwmodel/GRIDREST/?CLIENTE=#{cliente}&LOJA=#{
    #     loja
    #   }&COUNT=#{count}"

    {:ok, get} = HTTPoison.get(url, header)

    {:ok, Jason.decode!(get.body)}
  end

  @impl true
  def generate_boleto(token) do
    header = Protheus.authenticate(@header, token)

    url = Protheus.generate_url("/rest/fwmodel/SE4REST")

    # url = "httmp://hom.app.centraloftalmica.com:8080/rest/fwmodel/SE4REST"

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
              "E4_CODIGO" ->

                %{
                  "parcela" =>
                    "#{string_to_integer(field["value"])}x de #{(valor / 100 / string_to_integer(field["value"])) |> Float.round(2)}"
                }
                |> IO.inspect

              _ ->
                %{}
            end
          end)
        end)
      end)
      |> Enum.filter(fn map -> map != %{} end)
      |> Enum.map(fn map ->
        [_antes, depois] = String.split(map["parcela"], ".")
        case String.length(depois) < 2 do
          true -> %{"parcela" => map["parcela"] <> "0"}
          false -> %{"parcela" => map["parcela"]}
        end
      end)

    {:ok, organize_boleto}
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
                parse_field(field, acc)

              true ->
                acc
            end
          end)
        end)
      end)
      |> Map.new()

    {:ok, organize}
  end

  def parse_field(field, acc) do
    check = fn data ->
      case is_nil(data) do
        true -> ""
        false -> data
      end
    end

    case field["id"] do
      "A1_DTNASC" ->
        ano = String.slice(check.(field["value"]), 0..3)
        mes = String.slice(check.(field["value"]), 4..5)
        dia = String.slice(check.(field["value"]), 6..7)
        data_nascimento = "#{dia}#{mes}#{ano}"

        Map.put(acc, "A1_DTNASC", data_nascimento)

      "A1_CNAE" ->
        case Map.has_key?(acc, "A1_YCRM_CNAE") do
          true -> acc
          false -> Map.put(acc, "A1_YCRM_CNAE", field["value"])
        end

      "A1_YCRM" ->
        case Map.has_key?(acc, "A1_YCRM_CNAE") do
          true -> acc
          false -> Map.put(acc, "A1_YCRM_CNAE", field["value"])
        end

      _ ->
        Map.put(acc, field["id"], field["value"])
    end
  end
end
