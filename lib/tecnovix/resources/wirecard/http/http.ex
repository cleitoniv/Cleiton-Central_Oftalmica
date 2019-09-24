defmodule Tecnovix.Resource.Wirecard.SDK do
  import Ecto.Changeset

  @endpoint Application.fetch_env!(:tecnovix, :wirecard_endpoint)
  @access_token System.fetch_env!("ACCESS_TOKEN")
  @authorization [@access_token, @access_key]
                 |> Enum.join(":")
                 |> Base.encode64()

  @supported [:accounts, :customers, :orders]

  def http_post(data, url) when is_binary(url) do
    HTTPoison.post(url, Jason.encode!(data), [
      {"Authorization", "OAuth " <> @access_token},
      {"Content-Type", "application/json"}
    ])
  end

  def http_post(_data, {:error, :not_supported} = error), do: error

  def url(type) do
    case Enum.any?(@supported, fn method -> method == type end) do
      true -> @endpoint <> Atom.to_string(type)
      false -> {:error, :not_supported}
    end
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
end
