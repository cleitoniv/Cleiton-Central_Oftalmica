defmodule Tecnovix.Endpoints.ProtheusProd do
  @behaviour Tecnovix.Endpoints.Protheus

  @central_endpoint Application.fetch_env!(:tecnovix, :central_endpoint)

  @impl true
  def new_token(%{"username" => username, "password" => password}) do
    url =
      '#{@central_endpoint}/rest/api/oauth2/v1/token?grant_type=password&username=#{username}&password=#{
        password
      }'

    IO.inspect(url)
    # HTTPoison.post(url, [], [], [hackney: [:insecure], ssl: [{:versions, [:'tlsv1.2']}, {:verify, :verify_none}, {:server_name_indication, :disable}]])
    # Tesla.post(url, headers: [{"Content-Type", "application/x-www-form-urlencoded"}])
    :inets.start()
    :ssl.start()
    :httpc.request(:post, {url, []}, [ssl: [verify: :verify_none]])
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
