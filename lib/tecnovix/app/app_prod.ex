defmodule Tecnovix.App.ScreensProd do
  @behavior Tecnovix.App.Screens
  alias Tecnovix.ClientesModel
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.OpcoesCompraCreditoFinanceiroModel, as: OpcoesCreditoModel
  alias Tecnovix.Endpoints.Protheus
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema
  alias Tecnovix.AtendPrefClienteModel

  def get_endereco_entrega(_cliente) do
    endereco = %{
      cep: "29027-445",
      endereco: "Rua Dr.Eurico Aguiar",
      numero: "130",
      complemento: "Sala 609",
      bairro: "Santa Helena",
      cidade: "Vitória"
    }

    {:ok, endereco}
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
      "HASEIXO" -> "has_eixo"
      "HASGRAU" -> "has_esferico"
      "HASCILIND" -> "has_cilindrico"
      "HASADICAO" -> "has_adicao"
      "HASCOLOR" -> "has_cor"
      "HASCURVA" -> "has_curva"
      "HASDIAMET" -> "has_diametro"
      "HASRAIO" -> "has_raio"
      v -> v
    end
  end

  def organize_value(map) do
    case map["id"] do
      "HASEIXO" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASGRAU" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASCILIND" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASADICAO" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASCOLOR" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASCURVA" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASDIAMET" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      "HASRAIO" ->
        case map["value"] do
          "0" -> false
          "1" -> true
        end

      _ ->
        map["value"]
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

  def end_entrega(endereco, bairro, municipio, num, cep, complemento) do
    "#{endereco}, #{complemento}, #{bairro}, #{municipio}. #{cep}"
  end

  @impl true
  def get_product_grid(products, cliente, filtro) do
    grid =
      Enum.flat_map(products["resources"], fn resource ->
        Enum.map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn product, acc ->
            case Map.has_key?(acc, product["id"]) do
              false -> Map.put(acc, organize_field(product), organize_value(product))
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
      |> IO.inspect

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
    %{
      money: 5500,
      points: 100
    }
  end

  @impl true
  def get_dia_remessa(cliente) do
    case Repo.get(ClientesSchema, cliente.id) do
      nil ->
        {:error, :not_found}

      cliente ->
        case cliente.dia_remessa do
          nil -> "-"
          "1" -> "Segunda-feira"
          "2" -> "Terça-feira"
          "3" -> "Quarta-feira"
          "4" -> "Quinta-feira"
          "5" -> "Sexta-feira"
        end
    end
  end

  @impl true
  def get_notifications(_cliente) do
    notifications = %{
      opens: 2,
      notifications: [
        %{
          id: 0,
          lido: false,
          data: "2020-01-05",
          title: "Pedido Confirmado",
          mensagem: "Pagamento confirmado e a previsão de entrega é para 22/07/2019.",
          type: "PEDIDO_CONFIRMADO"
        },
        %{
          id: 1,
          lido: false,
          data: "2020-01-05",
          title: "Aguardando Pagamento",
          mensagem: "Estamos aguardando o pagamento do boleto referente ao pedido.",
          type: "AGUARDANDO_PAGAMENTO"
        },
        %{
          id: 2,
          lido: true,
          data: "2020-01-05",
          title: "Pedido Entregue",
          mensagem: "Entrega do seu pedido nº26555 efetuada com sucesso em seu endereço.",
          type: "PEDIDO_ENTREGUE"
        },
        %{
          id: 3,
          lido: true,
          data: "2020-01-05",
          title: "Reposição de Pedidos",
          mensagem: "Confira a lista de possiveis reposições de produtos para seus clientes.",
          type: "REPOSICAO_PEDIDOS"
        },
        %{
          id: 4,
          lido: true,
          data: "2020-01-05",
          title: "Boleto Vencido",
          mensagem: "Existem boletos vencidos em sua conta, pague-os para continuar comprando.",
          type: "BOLETO_VENCIDO"
        },
        %{
          id: 5,
          lido: true,
          data: "2020-01-05",
          title: "Boleto a Vencer",
          mensagem: "Existem boletos que estão prestes a vencer, não esqueça do pagamento.",
          type: "BOLETO_VENCER"
        },
        %{
          id: 6,
          lido: true,
          data: "2020-01-05",
          title: "Credito Financeiro",
          mensagem: "Confirmamos a sua compra de Créditos Financeiros para sua conta.",
          type: "FINANCEIRO_ADQUIRIDO"
        },
        %{
          id: 7,
          lido: true,
          data: "2020-01-05",
          title: "Credito de Produto",
          mensagem: "Confirmamos a sua compra de Créditos de Produtos para sua conta.",
          type: "PRODUTO_ADQUIRIDO"
        },
        %{
          id: 8,
          lido: true,
          data: "2020-01-05",
          title: "Resgate de Pontos",
          mensagem:
            "Adicionamos a sua conta o Crédito Financeiro referente ao Resgate de Pontos.",
          type: "RESGATE_PONTOS"
        },
        %{
          id: 9,
          lido: true,
          data: "2020-01-05",
          title: "Efetivação de Devolução",
          mensagem:
            "Sua solicitação de devolução em crédito ou troca foi analisada por nossa equipe.",
          type: "EFETIVACAO_DEV"
        },
        %{
          id: 10,
          lido: true,
          data: "2020-01-05",
          title: "Solicitação de Devolução",
          mensagem:
            "Recebemos sua solicitação de devolução em crédito ou troca, iremos analisá-la.",
          type: "SOLICITACAO_DEV"
        },
        %{
          id: 11,
          lido: true,
          data: "2020-01-05",
          title: "Lentes quase acabando!",
          mensagem: "O último pedido feito para seu paciente Luana, está quase acabando.",
          type: "LENTES_ACABANDO"
        }
      ]
    }

    {:ok, notifications}
  end

  @impl true
  def get_offers(_cliente) do
    {:ok, offers} =
      case OpcoesCreditoModel.get_offers() do
        [] -> {:ok, []}
        offers -> {:ok, offers}
      end

    offers =
      Enum.map(
        offers,
        fn map ->
          %{
            value: map.valor,
            installmentCount: map.prestacoes
          }
        end
      )

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
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 0,
        value_produto: 14100,
        value_finan: 14100,
        image_url: "teste.com.br",
        type: "miopia",
        boxes: 0
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 0,
        value_produto: 14100,
        value_finan: 14100,
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
          produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
          value: 30000,
          value_produto: 14100,
          value_finan: 14100,
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
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
        image_url: @product_url,
        type: "miopia",
        boxes: 2
      },
      %{
        id: 1,
        tests: 0,
        credits: 0,
        title: "Bioview Asférica A2",
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
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
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
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
        produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
        value: 15100,
        value_produto: 14100,
        value_finan: 14100,
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
      [] -> []
      cards -> {:ok, cards}
    end
  end

  @impl true
  def get_payments(_cliente, filtro) do
    payments = [
      %{
        id: 0,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "BOLETO",
        codigo_barra: "34191.79001 01043.510047 91020.150008 6 83820026000",
        status: 0
      },
      %{
        id: 1,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "CREDIT_CARD",
        status: 1
      },
      %{
        id: 2,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "CREDIT_CARD",
        status: 1
      },
      %{
        id: 3,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "CREDIT_FINAN",
        status: 1
      },
      %{
        id: 4,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "CREDIT_PRODUCT",
        status: 1
      },
      %{
        id: 5,
        vencimento: "30/03/20",
        nf: "6848529",
        valor: 12000,
        method: "BOLETO",
        codigo_barra: "34191.79001 01043.510047 91020.150008 6 83820026000",
        status: 2
      }
    ]

    result = Enum.filter(payments, fn payment -> payment.status == String.to_integer(filtro) end)
    {:ok, result}
  end

  defp parse_items(items) do
    Enum.map(items, fn item ->
      %{
        num_pac: item.num_pac,
        paciente: item.paciente,
        data_nascimento: item.data_nascimento,
        items: []
      }
    end)
    |> Enum.uniq_by(fn item -> item.num_pac end)
    |> Enum.map(fn paciente ->
      Enum.reduce(items, paciente, fn item, acc ->
        case item.num_pac == paciente.num_pac do
          true -> Map.put(acc, :items, acc.items ++ [item])
          false -> acc
        end
      end)
    end)
    |> Enum.map(fn paciente ->
      group_by =
        Enum.group_by(paciente.items, fn item -> item.codigo_item end)
        |> Enum.map(fn {codigo, codigo_items} ->
          Enum.reduce(codigo_items, %{}, fn codigo_item, acc ->
            p_olho = parse_olho(codigo_item)

            map =
              Map.put(acc, :valor_produto, codigo_item.valor_produto)
              |> Map.put(:quantidade, codigo_item.quantidade)
              |> Map.put(:valor_total, codigo_item.valor_total)
              |> Map.put(:olho, codigo_item.olho)
              |> Map.put(:url_image, "http://portal.centraloftalmica.com/images/#{codigo_item.grupo}.jpg")
              |> Map.put(:codigo_item, codigo_item.codigo_item)
              |> Map.put(:nome_produto, codigo_item.nome_produto)
              |> Map.put(:duracao, "1 Ano")
              |> Map.put(:grupo, codigo_item.grupo)
              |> Map.put(:type, codigo_item.type)
              |> Map.put(:operation, codigo_item.operation)

            Map.merge(map, p_olho)
          end)
        end)

      Map.put(paciente, :items, group_by)
    end)
  end

  defp parse_olho(item) do
    case item.olho do
      "D" ->
        %{
          esferico_d: item.esferico,
          eixo_d: item.eixo,
          cilindro_d: item.cilindro
        }

      "E" ->
        %{
          esferico_e: item.esferico,
          eixo_e: item.eixo,
          cilindro_e: item.cilindro
        }

      _ ->
        %{
          esferico_e: nil,
          eixo_e: nil,
          cilindro_e: nil
        }
    end
  end

  def get_pedido_id(cliente_id, pedido_id) do
    with {:ok, pedido} <- PedidosDeVendaModel.get_pedido_id(cliente_id, pedido_id) do
      pedido = %{
        data_inclusao: pedido.inserted_at,
        num_pedido: pedido.id,
        valor: Enum.reduce(pedido.items, 0, fn map, acc -> map.virtotal + acc end),
        frete: pedido.frete,
        valor_total:
          pedido.frete + Enum.reduce(pedido.items, 0, fn map, acc -> map.virtotal + acc end),
        previsao_entrega: pedido.previsao_entrega,
        items:
          Enum.map(
            pedido.items,
            fn item ->
              %{
                type: item.tipo_venda,
                operation: item.operation,
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
                grupo: item.grupo,
                url_image: "http://portal.centraloftalmica.com/images/#{item.grupo}.jpg",
                codigo_item: item.codigo_item,
                duracao: "1 ano"
              }
            end
          )
          |> parse_items()
      }

      {:ok, pedido}
    end
  end

  @impl true
  def get_mypoints(_cliente) do
    pedido_points = %{
      saldo: 50,
      pedidos: [
        %{
          id: 0,
          inclusao: "2020-08-15",
          valor: 12000,
          nome: "Marcos Barbosa Santos",
          points: "+2",
          num_pedido: "282740"
        },
        %{
          id: 1,
          inclusao: "2020-08-15",
          valor: 12000,
          nome: "Pedro de Oliveira Palaoro",
          points: "+2",
          num_pedido: "282739"
        },
        %{
          id: 2,
          inclusao: "2020-08-15",
          valor: 24000,
          nome: "Luana Oliveira",
          points: "+4",
          num_pedido: "282738"
        },
        %{
          id: 3,
          inclusao: "2020-08-15",
          valor: 36000,
          nome: "Oliver Ribeiro",
          points: "+5",
          num_pedido: "282740"
        }
      ]
    }

    {:ok, pedido_points}
  end

  @impl true
  def convert_points(_cliente, points) do
    points =
      case points do
        x -> %{"credit_finan" => 104}
      end

    {:ok, points}
  end

  @impl true
  def get_product_serie(_cliente, "010" <> _num_serie) do
    product = %{
      num_serie: "010C000001",
      id: 0,
      tests: 0,
      credits: 0,
      title: "Biosoft Asférica Mensal",
      produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
      value: 15100,
      value_produto: 14100,
      value_finan: 14100,
      image_url: @product_url,
      type: "miopia",
      boxes: 50,
      quantidade: 10,
      nf: "213_568_596",
      group: "010C"
    }

    {:ok, product}
  end

  @impl true
  def get_product_serie(_cliente, "011" <> num_serie) do
    product = %{
      num_serie: "011C" <> num_serie,
      id: 0,
      tests: 0,
      credits: 0,
      title: "Biosoft Asférica Mensal",
      produto: String.slice(Ecto.UUID.autogenerate(), 1..15),
      value: 15100,
      value_produto: 14100,
      value_finan: 14100,
      image_url: @product_url,
      type: "miopia",
      boxes: 50,
      quantidade: 10,
      nf: "213_568_596",
      group: "011C"
    }

    {:ok, product}
  end

  def get_extrato_finan(_cliente) do
    extrato = %{
      data: [
        %{
          id: 0,
          date: "10/02/2020",
          pedido: 23441,
          valor: 2000
        },
        %{
          id: 1,
          date: "07/02/2020",
          pedido: 213_545,
          valor: -2000
        },
        %{
          id: 2,
          date: "10/02/2020",
          pedido: 23441,
          valor: +3600
        }
      ],
      date: "Fevereiro/2020"
    }

    {:ok, extrato}
  end

  def get_extrato_prod(_cliente) do
    extrato = [
      %{
        id: 0,
        saldo: 1,
        produto: "Biosoft SIHY 45 CX3",
        items: [
          %{
            date: "2020/01/10",
            pedido: "23441",
            quantidade: 1
          },
          %{
            date: "2020/07/02",
            pedido: "213545",
            quantidade: -100
          }
        ]
      },
      %{
        id: 0,
        saldo: 1,
        produto: "Biosoft SIHY 45 CX3",
        items: [
          %{
            date: "2020/01/10",
            pedido: "23441",
            quantidade: 1
          },
          %{
            date: "2020/07/02",
            pedido: "213545",
            quantidade: -100
          }
        ]
      }
    ]

    {:ok, extrato}
  end

  @impl true
  def get_and_send_email_dev(email) do
    case Tecnovix.Email.send_email_dev(email) do
      {:ok, email} -> {:ok, email}
      _ -> {:error, :email_not_send}
    end
  end
end
