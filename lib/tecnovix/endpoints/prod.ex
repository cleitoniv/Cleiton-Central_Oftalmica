defmodule Tecnovix.Endpoints.ProtheusProd do
  @behaviour Tecnovix.Endpoints.Protheus

  @central_endpoint Application.fetch_env!(:tecnovix, :central_endpoint)

  @impl true
  def new_token(%{"username" => username, "password" => password}) do
    url = "#{@central_endpoint}/rest/api/oauth2/v1/token?grant_type=password&username=#{username}&password=#{password}"
    IO.inspect url
    HTTPoison.post(url, "", [{"Content-Type", "application/x-www-form-urlencoded"}])
  end

  @impl true
  def refresh_token(params) do

  end

  @impl true
  def dicrest(params) do

  end

  @impl true
  def get_cliente(params) do

  end
end
