defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema

  alias Tecnovix.{
    Repo,
    PedidosDeVendaSchema,
    PedidosDeVendaModel,
    ClientesSchema,
    UsuariosClienteSchema
  }

  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.CartaoCreditoClienteSchema, as: CartaoSchema
  import Ecto.Query

  @spec taxa_entrega :: {:ok, %{valor: 10}}
  def taxa_entrega() do
    taxa = %{
      valor: 10
    }

    {:ok, taxa}
  end

  @spec handle_items_with_test(nil | maybe_improper_list | map) :: nil | maybe_improper_list | map
  def handle_items_with_test(items) do
    Enum.map(items, fn items ->
      case items["operation"] == "07" or items["operation"] == "01" do
        true ->
          item =
            Enum.reduce(items["items"], [], fn item, acc ->
              case item["tests"] == "Sim" do
                true ->
                  item_teste =
                    Map.put(item, "produto", item["produto_teste"])
                    |> Map.put("grupo", item["grupo_teste"])

                  acc ++ [item |> Map.put("tests", "Não")] ++ [item_teste]

                false -> acc ++ [item]
              end
            end)

          Map.put(items, "items", item)

        false -> items
      end
    end)
  end

  def order_product_invoiced(cliente_id) do
    quantity_product_invoiced =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.client_id == ^cliente_id and (p.status_ped != 0 or p.status_ped != 4))
      |> Repo.all()
      |> Enum.flat_map(fn pedido ->
        Enum.reduce(pedido.items, [], fn items, acc ->
          case (items.status == 0 or items.status == 4) and items.tipo_venda == "C" and
                 items.operation == "07" do
            true ->
              map =
                Map.new()
                |> Map.put(:grupo, items.grupo <> items.tests)
                |> Map.put(:quantidade, items.quantidade)

              [map] ++ acc

            false ->
              acc
          end
        end)
      end)
      |> Enum.group_by(fn product -> product.grupo end, fn product_quantidade ->
        product_quantidade.quantidade
      end)

    {:ok, quantity_product_invoiced}
  end

  def sum_credits(cliente) do
    PedidosDeVendaSchema
    |> where([p], p.client_id == ^cliente.id)
    |> preload([p], :items)
    |> Repo.all()
    |> Enum.reduce(0, fn pedido, acc ->
      valor =
        Enum.reduce(pedido.items, 0, fn items_pedido, acc ->
          case items_pedido.status == 0 and items_pedido.operation == "13" do
            true -> acc + items_pedido.valor_credito_finan * items_pedido.quantidade
            false -> 0
          end
        end)

      valor + acc
    end)
  end

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn pedidos ->
       {:ok, item} =
         with nil <-
                Repo.get_by(PedidosDeVendaSchema, id: pedidos["id"]) do
           create_sync(pedidos)
         else
           changeset ->
             Repo.preload(changeset, :items)
             |> __MODULE__.update_sync(pedidos)
         end

       item
     end)}
  end

  def insert_or_update(%{"id" => id} = params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, id: id) do
      __MODULE__.create_sync(params)
    else
      changeset ->
        Repo.preload(changeset, :items)
        |> __MODULE__.update_sync(params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def update_sync(changeset, params) do
    PedidosDeVendaSchema.changeset_sync(changeset, params)
    |> Repo.update()
  end

  def create_sync(params) do
    %PedidosDeVendaSchema{}
    |> PedidosDeVendaSchema.changeset_sync(params)
    |> Repo.insert()
  end

  def somando_items(items) do
    Enum.reduce(items, 0, fn item, acc ->
      map =
        Enum.reduce(item, %{}, fn {key, value}, acc ->
          case key do
            "price" -> Map.put(acc, "price", value)
            "quantity" -> Map.put(acc, "quantidade", value)
            _ -> acc
          end
        end)

      acc + map["price"] * map["quantidade"]
    end)
  end

  def taxa_wirecard(items, installment, passo) do
    taxa =
      [
        {1, 0},
        {2, 4.5},
        {3, 5.0},
        {4, 5.5},
        {5, 6.5},
        {6, 7.5},
        {7, 8.5},
        {8, 9.5},
        {9, 10.5},
        {10, 11.5},
        {11, 12.0},
        {12, 12.5}
      ]
      |> Enum.filter(fn {parcela, _taxa} -> installment == parcela end)
      |> Enum.reduce(0, fn {_parcela, taxa}, _acc -> taxa end)

    case passo do
      "1" ->
        somando_items(items)
        |> calculo_taxa(taxa)
        |> Kernel.round()

      "2" ->
        {:ok, items} = items_order(items)

        somando_items(items)
        |> calculo_taxa(taxa)
        |> Kernel.round()
    end
  end

  def order(items, cliente, taxa_entrega, installment) do
    taxa = taxa_wirecard(items, installment, "1")

    order =
      cliente
      |> PedidosDeVendaModel.order_params(items)
      |> PedidosDeVendaModel.wirecard_order(taxa_entrega, taxa)
      |> Wirecard.create_order()

    case order do
      {:ok, %{status_code: 201}} -> order
      _ -> {:error, :order_not_created}
    end
  end

  def update_order(changeset, status) do
    changeset
    |> Ecto.Changeset.change(pago: status)
    |> Repo.update()
  end

  def payment(%{"id_cartao" => cartao_id}, order, ccv, installment) do
    order = Jason.decode!(order.body)
    order_id = order["id"]

    {:ok, payment} =
      cartao_id
      |> PedidosDeVendaModel.get_cartao_cliente()
      |> PedidosDeVendaModel.payment_params(ccv, installment)
      |> PedidosDeVendaModel.wirecard_payment()
      |> Wirecard.create_payment(order_id)

    payment = Jason.decode!(payment.body)

    case payment["status"] do
      "CANCELLED" ->
        try do
          raise payment["cancellationDetails"]["description"]
        rescue
          e in _ -> {:errorPayment, e.message}
        end

      _ ->
        {:ok, payment}
    end
  end

  def wirecard_order(params, taxa_entrega, taxa) do
    {:ok,
     %{
       "ownId" => params["ownId"],
       "amount" => %{
         "currency" => "BRL",
         "subtotals" => %{
           "shipping" => taxa_entrega,
           "addition" => taxa
         }
       },
       "items" => params["items"],
       "customer" => %{
         "ownId" => params["customers"]["ownId"],
         "fullname" => params["customers"]["fullname"],
         "email" => params["customers"]["email"],
         "birthDate" => params["customers"]["birthDate"],
         "taxDocument" => params["customers"]["taxDocument"],
         "phone" => params["customers"]["phone"],
         "shippingAddress" => params["customers"]["shippingAddress"]
       }
     }}
  end

  def wirecard_payment(params) do
    {:ok,
     %{
       "installmentCount" => params["installmentCount"],
       "statementDescriptor" => params["statementDescriptor"],
       "fundingInstrument" => params["fundingInstrument"]
     }}
  end

  def create_pedido(items, cliente, order, parcela, taxa_entrega) do
    case pedido_params(items, cliente, order, parcela, taxa_entrega) do
      {:ok, pedido} ->
        %PedidosDeVendaSchema{}
        |> PedidosDeVendaSchema.changeset(pedido)
        |> Repo.insert()

      _ ->
        {:error, :pedido_failed}
    end
  end

  def create_pedido(items, cliente, parcela, taxa_entrega) do
    case pedido_params(items, cliente, parcela, taxa_entrega) do
      {:ok, pedido} ->
        %PedidosDeVendaSchema{}
        |> PedidosDeVendaSchema.changeset(pedido)
        |> Repo.insert()

      _ ->
        {:error, :pedido_failed}
    end
  end

  defp verify_type(type, order) do
    case type do
      "A" -> Jason.decode!(order.body)["id"]
      "C" -> nil
      "T" -> nil
      _ -> nil
    end
  end

  def credito_items(items, map) do
    %{
      "tipo_venda" => "C",
      "operation" => map["operation"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "codigo" => items["codigo"],
      "produto" => items["produto"],
      "quantidade" => items["quantidade"],
      "prc_unitario" => items["prc_unitario"],
      "tests" => "N",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => String.slice(Ecto.UUID.autogenerate(), 0..10)
    }
  end

  def formatting_test(teste) do
    case teste do
      "Sim" -> "S"
      "Não" -> "N"
      _ -> teste
    end
  end

  def pedido_params(items, cliente, order, installment, taxa_entrega) do
    pedido = %{
      "client_id" => cliente.id,
      "tipo_pagamento" => "CREDIT_CARD",
      "parcela" => installment,
      "order_id" =>
        case order do
          nil -> verify_type(nil, order)
          _ -> verify_type("A", order)
        end,
      "taxa_wirecard" =>
        case order do
          nil -> 0
          _ -> taxa_wirecard(items, installment, "2")
        end,
      "taxa_entrega" =>
        case taxa_entrega do
          nil -> 0
          taxa_entrega -> taxa_entrega
        end,
      "loja" => cliente.loja,
      "cliente" => cliente.codigo,
      "pd_correios" => "",
      "vendedor_1" => "",
      "items" =>
        Enum.reduce(items, [], fn map, acc ->
          array =
            Enum.flat_map(map["items"], fn items ->
              IO.inspect(map)

              cond do
                map["olho_direito"] != nil ->
                  [olho_direito(items, map)]

                map["olho_esquerdo"] != nil ->
                  [olho_esquerdo(items, map)]

                map["olho_ambos"] != nil ->
                  items =
                    Map.put(items, "quantidade", (items["quantidade"] / 2) |> Kernel.trunc())

                  codigo = String.slice(Ecto.UUID.autogenerate(), 0..10)

                  [
                    olho_direito(input_codigo(items, codigo), map),
                    olho_esquerdo(input_codigo(items, codigo), map)
                  ]

                map["olho_diferentes"] != nil ->
                  codigo = String.slice(Ecto.UUID.autogenerate(), 0..10)

                  [
                    olho_diferentes_D(input_codigo(items, codigo), map),
                    olho_diferentes_E(input_codigo(items, codigo), map)
                  ]

                map["type"] == "C" ->
                  [credito_items(items, map)]
              end
            end)

          array ++ acc
        end)
    }

    {:ok, pedido}
  end

  # BOLETO
  def pedido_params(items, cliente, parcela, taxa_entrega) do
    pedido = %{
      "client_id" => cliente.id,
      "tipo_pagamento" => "BOLETO",
      "status_ped" => 0,
      "parcela" => parcela,
      "taxa_entrega" => taxa_entrega,
      "order_id" => nil,
      "loja" => cliente.loja,
      "cliente" => cliente.codigo,
      "pd_correios" => "",
      "vendedor_1" => "",
      "items" =>
        Enum.reduce(items, [], fn map, acc ->
          array =
            Enum.flat_map(map["items"], fn items ->
              cond do
                map["olho_direito"] != nil ->
                  [olho_direito(items, map)]

                map["olho_esquerdo"] != nil ->
                  [olho_esquerdo(items, map)]

                map["olho_ambos"] != nil ->
                  codigo = String.slice(Ecto.UUID.autogenerate(), 0..10)

                  [
                    olho_direito(input_codigo(items, codigo), map),
                    olho_esquerdo(input_codigo(items, codigo), map)
                  ]

                map["olho_diferentes"] != nil ->
                  codigo = String.slice(Ecto.UUID.autogenerate(), 0..10)

                  [
                    olho_diferentes_D(input_codigo(items, codigo), map),
                    olho_diferentes_E(input_codigo(items, codigo), map)
                  ]

                map["type"] == "C" ->
                  [credito_items(items, map)]
              end
            end)

          array ++ acc
        end)
    }

    {:ok, pedido}
  end

  def input_codigo(map, codigo) do
    Map.put(map, "codigo_item", codigo)
  end

  def olho_direito(items, map) do
    olho =
      cond do
        map["olho_direito"] != nil -> "olho_direito"
        map["olho_ambos"] != nil -> "olho_ambos"
        map["olho_diferentes"] != nil -> "olho_diferentes"
      end

    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
      "operation" => map["operation"],
      "codigo" => items["codigo"],
      "nocontrato" => items["nocontrato"],
      # "status" => items["status"],
      "produto" => items["produto"],
      "quantidade" => items["quantidade"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "tests" => formatting_test(items["tests"]),
      "prc_unitario" => items["prc_unitario"],
      "olho" => "D",
      "valor_credito_finan" => items["valor_credito_finan"],
      "valor_credito_prod" => items["valor_credito_prod"],
      "valor_test" => round(items["valor_test"] || 0.01),
      "virtotal" => items["quantidade"] * items["prc_unitario"],
      "esferico" => map[olho]["degree"],
      "cilindrico" => map[olho]["cylinder"],
      "eixo" => map[olho]["axis"],
      "cor" => map[olho]["cor"],
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map[olho]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "duracao" => formatting_duracao(items["duracao"]),
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => String.slice(Ecto.UUID.autogenerate(), 0..10),
      "status" => 0,
      "produto_teste" => items["produto_teste"]
    }
  end

  defp formatting_duracao(duracao) do
    duracao =
      case duracao do
        nil ->
          0

        "0" ->
          0

        duracao ->
          String.to_float(duracao)
          |> Kernel.trunc()
      end

    "#{duracao} dias"
  end

  def olho_esquerdo(items, map) do
    olho =
      cond do
        map["olho_esquerdo"] != nil -> "olho_esquerdo"
        map["olho_ambos"] != nil -> "olho_ambos"
      end

    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
      # "status" => items["status"],
      "operation" => map["operation"],
      "nocontrato" => items["nocontrato"],
      "codigo" => items["codigo"],
      "tests" => formatting_test(items["tests"]),
      "produto" => items["produto"],
      "quantidade" => items["quantidade"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "prc_unitario" => items["prc_unitario"],
      "valor_credito_finan" => items["valor_credito_finan"],
      "valor_credito_prod" => items["valor_credito_prod"],
      "valor_test" => round(items["valor_test"] || 0.01),
      "olho" => "E",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
      "esferico" => map[olho]["degree"],
      "cilindrico" => map[olho]["cylinder"],
      "eixo" => map[olho]["axis"],
      "cor" => map[olho]["cor"],
      "duracao" => formatting_duracao(items["duracao"]),
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map[olho]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => String.slice(Ecto.UUID.autogenerate(), 0..10),
      "status" => 0,
      "produto_teste" => items["produto_teste"]
    }
  end

  def olho_diferentes_D(items, map) do
    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
      # "status" => items["status"],
      "operation" => map["operation"],
      "nocontrato" => items["nocontrato"],
      "codigo" => items["codigo"],
      "tests" => formatting_test(items["tests"]),
      "produto" => items["produto"],
      "duracao" => formatting_duracao(items["duracao"]),
      "quantidade" => items["quantity_for_eye"]["direito"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "prc_unitario" => items["prc_unitario"],
      "valor_credito_finan" => items["valor_credito_finan"],
      "valor_credito_prod" => items["valor_credito_prod"],
      "valor_test" => round(items["valor_test"] || 0.01),
      "olho" => "D",
      "virtotal" => items["quantity_for_eye"]["direito"] * items["prc_unitario"],
      "esferico" => map["olho_diferentes"]["direito"]["degree"],
      "cilindrico" => map["olho_diferentes"]["direito"]["cylinder"],
      "eixo" => map["olho_diferentes"]["direito"]["axis"],
      "cor" => map["olhos_diferentes"]["cor"],
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map["olhos_diferentes"]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => items["codigo_item"],
      "status" => 0,
      "produto_teste" => items["produto_teste"]
    }
  end

  def olho_diferentes_E(items, map) do
    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
      "operation" => map["operation"],
      "duracao" => formatting_duracao(items["duracao"]),
      "codigo" => items["codigo"],
      # "status" => items["status"],
      "nocontrato" => items["nocontrato"],
      "produto" => items["produto"],
      "tests" => formatting_test(items["tests"]),
      "quantidade" => items["quantity_for_eye"]["esquerdo"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "prc_unitario" => items["prc_unitario"],
      "valor_credito_finan" => items["valor_credito_finan"],
      "valor_credito_prod" => items["valor_credito_prod"],
      "valor_test" => round(items["valor_test"] || 0.01),
      "olho" => "E",
      "virtotal" => items["quantity_for_eye"]["esquerdo"] * items["prc_unitario"],
      "esferico" => map["olho_diferentes"]["esquerdo"]["degree"],
      "cilindrico" => map["olho_diferentes"]["esquerdo"]["cylinder"],
      "eixo" => map["olho_diferentes"]["esquerdo"]["axis"],
      "cor" => map["olhos_diferentes"]["cor"],
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map["olhos_diferentes"]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => items["codigo_item"],
      "status" => 0,
      "produto_teste" => items["produto_teste"]
    }
  end

  def order_params(cliente = %ClientesSchema{}, items) do
    fisica_jurid =
      case cliente.fisica_jurid do
        "F" -> "CPF"
        "J" -> "CNPJ"
      end

    %{
      "ownId" => Ecto.UUID.autogenerate(),
      "amount" => %{
        "currency" => "BRL",
        "subtotals" => %{
          "shipping" => 0
        }
      },
      "items" => items,
      "customers" => %{
        "ownId" => Ecto.UUID.autogenerate(),
        "fullname" => cliente.nome,
        "email" => cliente.email,
        "birthDate" => cliente.data_nascimento,
        "taxDocument" => %{
          "type" => fisica_jurid,
          "number" => cliente.cnpj_cpf
        },
        "phone" => %{
          "countryCode" => "55",
          "areaCode" => cliente.ddd,
          "number" => cliente.telefone
        },
        "shippingAddress" => %{
          "city" => cliente.municipio,
          "complement" => cliente.complemento,
          "district" => cliente.bairro,
          "street" => cliente.endereco,
          "streetNumber" => cliente.numero,
          "zipCode" => cliente.cep,
          "state" => cliente.estado,
          "country" => "BRA"
        }
      }
    }
  end

  def order_params(usuario_cliente = %UsuariosClienteSchema{}, items) do
    usuario_cliente = Repo.preload(usuario_cliente, :cliente)

    __MODULE__.order_params(usuario_cliente.cliente, items)
  end

  def payment_params({:ok, cartao = %CartaoSchema{}}, ccv, installment) do
    %{
      "installmentCount" => installment,
      "statementDescriptor" => "central",
      "fundingInstrument" => %{
        "method" => "CREDIT_CARD",
        "creditCard" => %{
          "expirationYear" => String.slice(cartao.ano_validade, 2..3),
          "expirationMonth" => cartao.mes_validade,
          "number" => cartao.cartao_number,
          "cvc" => ccv,
          "holder" => %{
            "fullname" => cartao.nome_titular,
            "birthdate" => Date.to_string(cartao.data_nascimento_titular),
            "taxDocument" => %{
              "type" => "CPF",
              "number" => cartao.cpf_titular
            },
            "phone" => %{
              "countryCode" => "55",
              "areaCode" => String.slice(cartao.telefone_titular, 2..3),
              "number" => String.slice(cartao.telefone_titular, 4..13)
            },
            "billingAddress" => %{
              "city" => cartao.cidade_endereco_cobranca,
              "district" => cartao.bairro_endereco_cobranca,
              "street" => cartao.logradouro_endereco_cobranca,
              "streetNumber" => cartao.numero_endereco_cobranca,
              "zipCode" => cartao.cep_endereco_cobranca,
              "state" => cartao.estado_endereco_cobranca,
              "country" => "BRA"
            }
          }
        }
      }
    }
  end

  def get_payments_credit_card(cliente_id) do
    pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.client_id == ^cliente_id and p.tipo_pagamento == "CREDIT_CARD")
      |> Repo.all()

    pedidos_ready =
      Enum.flat_map(pedidos, fn pedido ->
        Enum.reduce(pedido.items, [], fn items, acc ->
          case (items.tipo_venda == "C" and items.operation == "06") or
                 (items.tipo_venda == "A" and items.operation == "01" and pedido.pago == "S") do
            true -> acc ++ [pedido]
            false -> acc
          end
        end)
      end)

    {:ok, pedidos_ready}
  end

  def get_payments_boleto(cliente_id) do
    pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.client_id == ^cliente_id and p.tipo_pagamento == "BOLETO")
      |> Repo.all()

    pedidos_ready =
      Enum.flat_map(pedidos, fn pedido ->
        Enum.reduce(pedido.items, [], fn items, acc ->
          case items.tipo_venda == "A" and items.operation == "01" do
            true -> acc ++ [pedido]
            false -> acc
          end
        end)
      end)

    {:ok, pedidos_ready}
  end

  def get_cliente_by_id(id) do
    case Repo.get_by(ClientesSchema, id: id) do
      nil -> :error
      cliente -> {:ok, cliente}
    end
  end

  def items_order(items) do
    order_items =
      Enum.reduce(
        items,
        [],
        fn item, acc ->
          list =
            case item["operation"] do
              "01" ->
                Enum.map(item["items"], fn order ->
                  %{
                    "product" => order["produto"],
                    "category" => "OTHER_CATEGORIES",
                    "quantity" => order["quantidade"],
                    "detail" => "Mais info...",
                    "price" => order["prc_unitario"]
                  }
                end)

              "06" ->
                case item["type"] do
                  "C" ->
                    Enum.map(item["items"], fn order ->
                      %{
                        "product" => order["produto"],
                        "category" => "OTHER_CATEGORIES",
                        "quantity" => order["quantidade"],
                        "detail" => "Mais info...",
                        "price" => order["prc_unitario"]
                      }
                    end)

                  _ ->
                    []
                end

              _ ->
                []
            end

          list ++ acc
        end
      )

    {:ok, order_items}
  end

  @spec get_cartao_cliente(any) :: {:error, :cartao_not_found} | {:ok, any}
  def get_cartao_cliente(id) do
    case Repo.get_by(CartaoSchema, id: id) do
      nil ->
        {:error, :cartao_not_found}

      cartao_cliente ->
        {:ok, cartao_cliente}
    end
  end

  def get_pedidos(cliente_id, filtro) do
    case filtro do
      "2" ->
        get_pacientes_revisao(cliente_id)

      "0" ->
        _pedidos =
          PedidosDeVendaSchema
          |> preload(:items)
          |> where(
            [p],
            (p.client_id == ^cliente_id and p.status_ped == ^filtro) or p.status_ped == 3
          )
          |> order_by([p], desc: p.inserted_at)
          |> Repo.all()

      _ ->
        _pedidos =
          PedidosDeVendaSchema
          |> preload(:items)
          |> where([p], p.client_id == ^cliente_id and p.status_ped == ^filtro)
          |> order_by([p], desc: p.inserted_at)
          |> Repo.all()
    end
  end

  def get_pedidos_finan(cliente_id) do
    _pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.client_id == ^cliente_id)
      |> Repo.all()
      |> Enum.reduce([], fn pedido, acc ->
        pedido.items ++ acc
      end)
      |> Enum.filter(fn item -> item.operation == "13" end)
  end

  def confirm_buy(money, [%{"operation" => "13"} = pedido]) do
    valor_pedido =
      Enum.reduce(pedido["items"], 0, fn items, acc ->
        items["quantidade"] * items["valor_credito_finan"] + acc
      end)

    case valor_pedido < money do
      true -> {:ok, true}
      false -> {:ok, false}
    end
  end

  def confirm_buy(_money, _pedido), do: {:ok, true}

  def get_pacientes_revisao(cliente_id) do
    pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.client_id == ^cliente_id)
      |> order_by([p], desc: p.inserted_at)
      |> Repo.all()

    case pedidos do
      [] -> []
      pedido -> parse_pedidos_to_revisao(pedido)
    end
  end

  def parse_pedidos_to_revisao(pedidos) do
    pedidos =
      Enum.flat_map(pedidos, fn pedido ->
        Enum.map(pedido.items, fn item ->
          Map.put(pedido, :items, [item])
        end)
      end)

    Enum.filter(pedidos, fn item ->
      paciente =
        Enum.map(item.items, fn items ->
          items.paciente
        end)

      paciente != [nil]
    end)
    |> Enum.filter(fn pedido ->
      duracao =
        Enum.map(pedido.items, fn item ->
          item.duracao
        end)

      data_hoje = Date.utc_today()

      duracao =
        String.replace(hd(duracao), ~r/[^\d]/, "")
        |> String.to_integer()

      count_range = Date.diff(duracao_mais_data_insercao(pedido, duracao), data_hoje)

      count_range <= 30 and count_range >= 0
    end)
    |> Enum.map(fn map ->
      Map.put(map, :item_pedido, Enum.at(map.items, 0).id)
    end)
  end

  def duracao_mais_data_insercao(item, duracao) do
    Date.add(NaiveDateTime.to_date(item.inserted_at), duracao)
  end

  def create_credito_financeiro(items, cliente, %{"type" => _type, "operation" => _operation}) do
    case pedido_params(items, cliente, "", 0) do
      {:ok, pedido} ->
        %PedidosDeVendaSchema{}
        |> PedidosDeVendaSchema.changeset(pedido)
        |> Repo.insert()

      _ ->
        {:error, :pedido_failed}
    end
  end

  def get_pedido_id(pedido_id, _cliente_id) do
    case Repo.get(PedidosDeVendaSchema, pedido_id) do
      nil ->
        {:error, :not_found}

      pedido ->
        pedido = Repo.preload(pedido, :items)

        {:ok, pedido}
    end
  end

  def get_pedidos_protheus(filtro, nil) do
    pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.status_ped == ^filtro)
      |> order_by([p], asc: p.inserted_at)
      |> Repo.all()

    case pedidos do
      [] -> {:error, :not_found}
      pedidos -> {:ok, pedidos}
    end
  end

  def get_pedidos_protheus(filtro, nao_integrado) do
    pedidos =
      PedidosDeVendaSchema
      |> preload(:items)
      |> where([p], p.status_ped == ^filtro and p.integrado == ^nao_integrado)
      |> order_by([p], asc: p.inserted_at)
      |> Repo.all()

    case pedidos do
      [] -> {:error, :not_found}
      pedidos -> {:ok, pedidos}
    end
  end

  def calculo_taxa(valor, taxa) do
    case valor do
      0 ->
        0

      valor ->
        taxa_cartao = valor * 0.0549 + 0.69 * 100
        taxa_parcelamento = valor * (taxa / 100)
        taxa_cartao + taxa_parcelamento
    end
  end

  def taxa(valor, parcelado) do
    list_taxa =
      [
        {1, 0},
        {2, 4.5},
        {3, 5.0},
        {4, 5.5},
        {5, 6.5},
        {6, 7.5},
        {7, 8.5},
        {8, 9.5},
        {9, 10.5},
        {10, 11.5},
        {11, 12.0},
        {12, 12.5}
      ]
      |> Enum.filter(fn {parcela, _taxa} -> parcela <= parcelado end)

    resp =
      Enum.map(list_taxa, fn {parcela, taxa} ->
        result =
          ((calculo_taxa(valor, taxa) / 100 + valor / 100) / parcela)
          |> Float.round(2)

        case parcela do
          1 ->
            %{"parcela" => "#{parcela}x de #{result}"}

          _ ->
            %{"parcela" => "#{parcela}x de #{result}"}
        end
      end)
      |> Enum.map(fn map ->
        [_antes, depois] = String.split(map["parcela"], ".")

        case String.length(depois) < 2 do
          true -> %{"parcela" => map["parcela"] <> "0"}
          false -> %{"parcela" => map["parcela"]}
        end
      end)

    {:ok, resp}
  end

  def parcelas() do
    parcelas = 12

    {:ok, parcelas}
  end

  def get_order_contrato(cliente_id) do
    pedidos =
      PedidosDeVendaSchema
      |> where([p], p.client_id == ^cliente_id)
      |> preload([i], :items)
      |> Repo.all()
      |> Enum.flat_map(fn pedido ->
        Enum.filter(pedido.items, fn filter ->
          filter.tipo_venda == "C" and filter.tests == "N"
        end)
      end)

    {:ok, pedidos}
  end
end
