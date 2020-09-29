defmodule Tecnovix.App.ScreensProd do
  @behavior Tecnovix.App.Screens
  alias Tecnovix.Endpoints.Protheus

  defp end_entrega(endereco, bairro, municipio, num, cep, complemento) do
    "#{endereco}, #{complemento}, #{bairro}, #{municipio}. #{cep}"
  end

  def organize_field(map) do
    case map["id"] do
      "BM_DESC" -> "title"
      "SALDO" -> "boxes"
      "SALDOTESTE" -> "tests"
      "VALORA" -> "value"
      "VALORC" -> "value_produto"
      "VALORE" -> "value_finan"
      "BM_GRUPO" -> "group"
      v -> v
    end
  end

  def value_cents_1(key, acc) do
    case key do
      "boxes" -> Map.put(acc, key, String.to_float(acc[key]) |> floor())
      "tests" -> Map.put(acc, key, String.to_float(acc[key]) |> floor())
      _ -> Map.put(acc, key, (String.to_float(acc[key]) |> floor()) * 100)
    end
  end

  def value_cents_2(key, acc) do
    case key do
      "boxes" -> Map.put(acc, key, String.to_integer(acc[key]))
      "tests" -> Map.put(acc, key, String.to_integer(acc[key]))
      _ -> Map.put(acc, key, String.to_integer(acc[key]) * 100)
    end
  end

  @impl true
  def get_product_grid(products, cliente, filtro) do
    grid =
      Enum.flat_map(products["resources"], fn resource ->
        Enum.map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn product, acc ->
            case Map.has_key?(acc, product["id"]) do
              false -> Map.put(acc, organize_field(product), product["value"])
              true -> acc
            end
          end)
          |> Map.put("type", "miopia")
          |> Map.put("visint", true)
          |> Map.put("previsao_entrega", 5)
          |> Map.put("graus_esferico", [-0.5, 0.75, 1.0, 1.5])
          |> Map.put("graus_eixo", [-0.5, 0.75, 1.0, 1.5])
          |> Map.put("graus_cilindrico", [-0.5, 0.75, 1.0, 1.5])
          |> Map.put(
            "end_entrega",
            end_entrega(
              cliente.endereco,
              cliente.bairro,
              cliente.municipio,
              cliente.numero,
              cliente.cep,
              cliente.complemento
            )
          )
        end)
      end)

    list = ["boxes", "tests", "value", "value_produto", "value_finan"]

    produtos =
      Enum.map(grid, fn map ->
        map =
          Map.put(
            map,
            "image_url",
            "http://portal.centraloftalmica.com/images/#{map["group"]}.jpg"
          )

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
