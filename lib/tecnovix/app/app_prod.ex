defmodule Tecnovix.App.ScreensProd do
  @behavior Tecnovix.App.Screens

  @impl true
  def get_product_grid(cliente, filtro) do
    protheus = Protheus.stub()

    {:ok, products} = protheus.get_client_products(cliente)

    products = Jason.decode!(products)

    grid =
      Enum.flat_map(products["resources"], fn resource ->
        Enum.map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn product, acc ->
            case Map.has_key?(acc, product["id"]) do
              false -> Map.put(acc, organize_field(product), product["value"])
              true -> acc
            end
          end)
          |> Map.put("image_url", @product_url)
          |> Map.put("type", "miopia")
          |> Map.put("visint", true)
        end)
      end)

    list = ["boxes", "tests", "value", "value_produto", "value_finan"]

    produtos =
      Enum.map(grid, fn map ->
        Enum.reduce(list, map, fn key, acc ->
          cond do
            acc[key] == "0" -> Map.put(acc, key, 0)
            String.contains?(acc[key], ".") -> value_cents_1(key, acc)
            true -> value_cents_2(key, acc)
          end
        end)
      end)

    data =
      case filtro do
        "all" -> produtos
        _ -> Enum.filter(produtos, fn items -> items["type"] == filtro end)
      end

    {:ok, data}
  end

  @impl true
  def get_credits(_cliente) do
  end

  @impl true
  def get_notifications(_cliente) do
  end

  @impl true
  def get_offers(_cliente) do
  end

  @impl true
  def get_products_credits(_cliente, _filtro) do
  end

  @impl true
  def get_products_cart(_cliente) do
  end

  @impl true
  def get_info_products(_cliente) do
  end

  @impl true
  def get_detail_order(_cliente) do
  end

  @impl true
  def get_payments(_cliente, _filtro) do
  end

  @impl true
  def get_product_serie(_cliente, _num_serie) do
  end

  @impl true
  def get_extrato_finan(_cliente) do
  end

  @impl true
  def get_extrato_prod(_cliente) do
  end

  @impl true
  def get_and_send_email_dev(_email) do
  end

  @impl true
  def convert_points(_cliente) do
  end
end
