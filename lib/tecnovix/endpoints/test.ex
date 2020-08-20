defmodule Tecnovix.Endpoints.ProtheusTest do
  @behaviour Tecnovix.Endpoints.Protheus

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
  def get_cliente(_params) do
    resp = Jason.encode!(Tecnovix.TestHelp.cliente())

    {:ok, %{status_code: 200, body: resp}}
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
end
