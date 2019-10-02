defmodule Tecnovix.Resource.Wirecard.SDK do
  @moduledoc false

  @endpoint Application.fetch_env!(:tecnovix, :wirecard_endpoint)
  @access_token Application.fetch_env!(:tecnovix, :moip_access_token)

  @supported [:accounts, :customers, :orders, :payments, :escrows]

  def http_post(data, url) when is_binary(url) do
    HTTPoison.post(url, Jason.encode!(data), [
      {"Authorization", "OAuth " <> @access_token},
      {"Content-Type", "application/json"}
    ])
  end

  def http_post(_data, {:error, :not_supported} = error), do: error

  def http_post(url) do
    HTTPoison.post(url, [], [
      {"Authorization", "OAuth " <> @access_token},
      {"Content-Type", "application/json"}
    ])
  end

  def http_get(url) do
    HTTPoison.get(url, [
      {"Authorization", "OAuth " <> @access_token},
      {"Content-Type", "application/json"}
    ])
  end

  def http_delete(url) do
    HTTPoison.delete(url, [], [
      {"Authorization", "OAuth " <> @access_token},
      {"Content-Type", "application/json"}
    ])
  end

  def url(type) do
    case Enum.any?(@supported, fn method -> method == type end) do
      true -> @endpoint <> Atom.to_string(type)
      false -> {:error, :not_supported}
    end
  end

  def url() do
    @endpoint
  end

  def create(changeset = %Ecto.Changeset{valid?: true}, cliente_id, :credit_card) do
    http_post(changeset.params, url(:customers) <> "/#{cliente_id}/fundinginstruments")
  end

  def create(changeset = %Ecto.Changeset{valid?: true}, order_id, :payment) do
    http_post(changeset.params, url(:orders) <> "/#{order_id}/payments")
  end

  def create(changeset = %Ecto.Changeset{valid?: true}, type) do
    http_post(changeset.params, url(type))
  end

  def escrow_release(escrow_id) do
    http_post(url(:escrows) <> "/#{escrow_id}/release")
  end

  def delete(id, :credit_card) do
    http_delete(url() <> "fundinginstruments/#{id}")
  end

  def get(id, type) do
    http_get(url(type) <> "/#{id}")
  end
end
