defmodule Tecnovix.App.ScreensTest do
  @behavior Tecnovix.App.Screens
  alias Tecnovix.ClientesModel
  alias Tecnovix.PedidosDeVendaModel

  @product_url "https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417"

  @impl true
  def get_product_grid(_cliente, filtro) do
    produtos = [
      %{
        id: 0,
        tests: 0,
        credits: 0,
        title: "Biosoft Asférica Mensal",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 0
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 0
      },
      %{
        id: 2,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A3",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 0
      },
      %{
        id: 3,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A4",
        value: 15100,
        image_url: @product_url,
        type: "hipermetropia",
        boxes: 0
      }
    ]

    data =
      case filtro do
        "all" -> produtos
        _ -> Enum.filter(produtos, fn items -> items.type == filtro end)
      end

    {:ok, data}
  end

  @impl true
  def get_credits(_cliente) do
    %{
      money: 5500,
      points: 100
    }
  end

  @impl true
  def get_notifications_open(_cliente) do
    %{
      opens: 2
    }
  end

  @impl true
  def get_offers(_cliente) do
    offers = [
      %{
        value: 2500,
        installmentCount: 1
      },
      %{
        value: 5000,
        installmentCount: 3
      },
      %{
        value: 10000,
        installmentCount: 5
      }
    ]

    {:ok, offers}
  end

  @impl true
  def get_products_credits(_cliente) do
    products = [
      %{
        id: 0,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A1",
        value: 0,
        image_url: "teste.com.br",
        type: "miopia",
        boxes: 0
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        value: 0,
        image_url: "teste.com.br",
        type: "miopia",
        boxes: 0
      }
    ]

    {:ok, products}
  end

  @impl true
  def get_order(_cliente, filtro) do
    orders = [
      %{
        paciente: "Marcos Barbosa Santos",
        pedido: "282740",
        date: "2020-08-15",
        value: 12000,
        status: "pendentes"
      },
      %{
        paciente: "Marcos Barbosa Santos",
        pedido: "282740",
        date: "2020-08-15",
        value: 12000,
        status: "entregues"
      },
      %{
        paciente: "Marcos Barbosa Santos",
        pedido: "282740",
        date: "2020-08-15",
        value: 12000,
        status: "reposição"
      }
    ]

    orders = Enum.filter(orders, fn x -> x.status == filtro end)
    {:ok, orders}
  end

  @impl true
  def get_products_cart(_cliente) do
    cart = [
      %{
        products: %{
          id: 0,
          title: "Bioview Asferica Cx 6",
          value: 30000,
          quantity: 2,
          buy_type: "Avulso"
        },
        delivery_fee: 10000,
        total: 40000
      }
    ]

    {:ok, cart}
  end

  @impl true
  def get_info_product(_cliente, id) do
    product = [
      %{
        id: 0,
        tests: 0,
        credits: 0,
        title: "Biosoft Asférica Mensal",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 2,
        description: "Produzido com material hidrofilico...",
        material: "Hidrogel Methafilcon",
        dk_t: 21,
        visint: true,
        espessura: "0,09mm",
        hidratacao: "55%",
        assepsia: "Quimica",
        descarte: "Mensal",
        desenho: "Asférico",
        diametro: "14.4",
        curva_base: 21,
        esferico: "+8.00 a -10.00"
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 0,
        description: "Produzido com material hidrofilico...",
        material: "Hidrogel Methafilcon",
        dk_t: 21,
        visint: true,
        espessura: "0,09mm",
        hidratacao: "55%",
        assepsia: "Quimica",
        descarte: "Mensal",
        desenho: "Asférico",
        diametro: "14.4",
        curva_base: 21,
        esferico: "+8.00 a -10.00"
      },
      %{
        id: 2,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A3",
        value: 15100,
        image_url: @product_url,
        type: "miopia",
        boxes: 0,
        description: "Produzido com material hidrofilico...",
        material: "Hidrogel Methafilcon",
        dk_t: 21,
        visint: true,
        espessura: "0,09mm",
        hidratacao: "55%",
        assepsia: "Quimica",
        descarte: "Mensal",
        desenho: "Asférico",
        diametro: "14.4",
        curva_base: 21,
        esferico: "+8.00 a -10.00"
      },
      %{
        id: 3,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A4",
        value: 15100,
        image_url: @product_url,
        type: "hipermetropia",
        boxes: 0,
        description: "Produzido com material hidrofilico...",
        material: "Hidrogel Methafilcon",
        dk_t: 21,
        visint: true,
        espessura: "0,09mm",
        hidratacao: "55%",
        assepsia: "Quimica",
        descarte: "Mensal",
        desenho: "Asférico",
        diametro: "14.4",
        curva_base: 21,
        esferico: "+8.00 a -10.00"
      }
    ]

    product =
      Enum.filter(product, fn product -> product.id == String.to_integer(id) end)
      |> Enum.at(0)

    {:ok, product}
  end

  def get_product_by_id(id) do
    case Tecnovix.Repo.get_by(Tecnovix.App.ProductModel, id: id) do
      nil -> {:error, :not_found}
      product -> {:ok, product}
    end
  end

  @impl true
  def get_detail_order(cliente, filtro) do
    detail =
      Enum.map(
        PedidosDeVendaModel.get_pedidos(cliente.id, filtro),
        fn map ->
          %{
            valor: Enum.reduce(map.items, 0, fn item, acc -> item.virtotal + acc end),
            data_inclusao: map.inserted_at,
            num_pedido: map.id
          }
        end
      )

    {:ok, detail}
  end

  @impl true
  def get_cards(cliente) do
    case ClientesModel.get_cards(cliente) do
      [] -> :not_found
      cards -> {:ok, cards}
    end
  end

  @impl true
  def get_payments(_cliente) do
    %{
      total: 400,
      number: "**** **** **** 1234",
      avista: "A vista (5% de desconto)",
      x2: "2x(3% de desconto)",
      x3: "3x(2% de desconto)",
      x4: "4x"
    }
  end

  def get_pedido_id(cliente_id, pedido_id) do
    with {:ok, pedido} <- PedidosDeVendaModel.get_pedido_id(cliente_id, pedido_id) do
      pedido = %{
        data_inclusao: pedido.inserted_at,
        num_pedido: pedido.numero,
        type: pedido.tipo_venda,
        items:
          Enum.map(
            pedido.items,
            fn item ->
              %{
                num_pac: item.num_pac,
                paciente: item.paciente,
                data_nascimento: item.dt_nas_pac,
                nome_produto: item.produto,
                valor_produto: item.prc_unitario,
                quantidade: item.quantidade,
                valor_total: item.virtotal,
                olho: item.olho,
                esferico: item.esferico,
                eixo: item.eixo,
                cilindro: item.cilindrico,
                url_image: item.url_image,
                duracao: "1 ano",
                previsao_entrega: "2020-10-27"
              }
            end
          )
        }

      {:ok, pedido}
    end
  end
end
