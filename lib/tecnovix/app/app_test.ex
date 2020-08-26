defmodule Tecnovix.App.ScreensTest do
  @behavior Tecnovix.App.Screens

  @impl true
  def get_product_grid(_cliente, filtro) do
    produtos = [
      %{
        id: 0,
        tests: 0,
        credits: 0,
        title: "Biosoft Asférica Mensal",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia"
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia"
      },
      %{
        id: 2,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A3",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia"
      },
      %{
        id: 3,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A4",
        value: 15100,
        image_url: "teste.com.br",
        type: "hipermetropia"
      }
    ]

    data = Enum.filter(produtos, fn items -> items.type == filtro end)

    {:ok, data}
  end

  @impl true
  def get_credits(_cliente) do
    %{
      money: 5000,
      points: 50
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
        type: "miopia"
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        value: 0,
        image_url: "teste.com.br",
        type: "miopia"
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
        rate: 10000,
        total: 40000
      }
    ]

    {:ok, cart}
  end

  @impl true
  def get_info_products(_cliente) do
    info = [
      %{
        id: 0,
        tests: 30,
        credits: 0,
        title: "Bioview Asférica Cx 6",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia",
        boxs: 2
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica Cx 6",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia",
        caixas: 0
      },
      %{
        id: 4,
        tests: 30,
        credits: 500_000,
        title: "Bioview Asférica Cx 6",
        value: 15100,
        image_url: "teste.com.br",
        type: "miopia",
        caixas: 0
      }
    ]
  end
end
