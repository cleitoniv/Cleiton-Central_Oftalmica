defmodule Tecnovix.Endpoints.Protheus do
  @callback token(term) :: {:ok, term}
  @callback refresh_token(term) :: {:ok, term}
  @callback get_cliente(cliente :: term) :: {:ok, term}
  @callback get_address_by_cep(term) :: {:ok, term}
  @callback get_delivery_prevision(term) :: {:ok, term}
  @callback get_product_by_serial(term) :: {:ok, term}
  @callback get_client_products(products :: term) :: {:ok, term}
  @callback get_client_points(term) :: {:ok, term}
  @callback generate_boleto(term) :: {:ok, term}

  @central_endpoint Application.fetch_env!(:tecnovix, :central_endpoint)

  def authenticate(headers, token) do
    headers ++ [{"Authorization", "Bearer " <> token}]
  end

  def generate_url(part) do
    @central_endpoint <> part
  end

  def generate_url(part, query) when is_map(query) do
    @central_endpoint <> part <> "?" <> URI.encode_query(query)
  end

  def stub() do
    case Mix.env() do
      :test -> Tecnovix.Endpoints.ProtheusTest
      :prod -> Tecnovix.Endpoints.ProtheusProd
      :dev -> Tecnovix.Endpoints.ProtheusTest
    end
  end
end
