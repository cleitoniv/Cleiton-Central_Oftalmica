defmodule Tecnovix.Services.Auth do
  use GenServer
  alias Tecnovix.Endpoints.Protheus

  @username Application.fetch_env!(:tecnovix, :protheus_username)
  @password Application.fetch_env!(:tecnovix, :protheus_password)
  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :protheus_auth_services)
  end

  def get_token() do
    protheus = Protheus.stub()
    {:ok, token} = protheus.token(%{username: @username, password: @password}) |> IO.inspect()

    case token.status_code do
      201 ->
        {:ok, %{stub: protheus, auth: Jason.decode!(token.body)}}

      _ ->
        {:error, "Token invalida"}
    end
  end

  def init(_) do
    with {:ok, state} = resp <- get_token() do
      Process.send_after(self(), {:refresh, state}, 30 * 60000)
      resp
    else
      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_info({:refresh, auth}, state) do
    {:ok, token} = auth.stub.refresh_token(%{refresh_token: auth.auth["refresh_token"]})

    case token.status_code do
      201 ->
        Process.send_after(self(), {:refresh, state}, 30 * 60000)
        {:noreply, Map.put(state, :auth, Jason.decode!(token.body))}

      _ ->
        {:stop, "Token Invalida"}
    end
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state.auth}, state}
  end

  def token() do
    GenServer.call(:protheus_auth_services, :get)
  end
end
