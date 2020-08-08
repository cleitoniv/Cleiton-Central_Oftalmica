defmodule Tecnovix.EndpointAuth do

  def auth(%{username: _username, password: _password} = params) do
    params = Map.put(params, :grant_type, "password")

    url = "https://hom.app.centraloftalmica.com:8080/rest/api/oauth2/v1/token?grant_type=password&username=usuario&password=senha"

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end
end
