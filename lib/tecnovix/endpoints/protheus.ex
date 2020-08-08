defmodule Tecnovix.Endpoints.Protheus do
  @callback new_token(term) :: {:ok, term}
  @callback refresh_token(term) :: {:ok, term}
  @callback dicrest(term) :: {:ok, term}
  @callback get_cliente(term) :: {:ok, term}

  def stub() do
    case Mix.env() do
      :test -> Tecnovix.Endpoints.ProtheusTest
      :prod -> Tecnovix.Endpoints.ProtheusProd
    end
  end
end
