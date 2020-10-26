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

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn pedidos ->
       {:ok, item} =
         with nil <-
                Repo.get_by(PedidosDeVendaSchema,
                  filial: pedidos["filial"],
                  numero: pedidos["numero"]
                ) do
           create_sync(pedidos)
         else
           changeset ->
             Repo.preload(changeset, :items)
             |> __MODULE__.update_sync(pedidos)
         end

       item
     end)}
  end

  def insert_or_update(%{"filial" => filial, "numero" => numero} = params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, filial: filial, numero: numero) do
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

  def order(items, cliente) do
    order =
      cliente
      |> PedidosDeVendaModel.order_params(items)
      |> PedidosDeVendaModel.wirecard_order()
      |> Wirecard.create_order()

    case order do
      {:ok, %{status_code: 201}} -> order
      _ -> {:error, :order_not_created}
    end
  end

  def update_order(changeset) do
    changeset
    |> Ecto.Changeset.change(status_ped: 1)
    |> Repo.update()
  end

  def payment(%{"id_cartao" => cartao_id}, order) do
    order = Jason.decode!(order.body)
    order_id = order["id"]

    payment =
      cartao_id
      |> PedidosDeVendaModel.get_cartao_cliente()
      |> PedidosDeVendaModel.payment_params()
      |> PedidosDeVendaModel.wirecard_payment()
      |> Wirecard.create_payment(order_id)

    case payment do
      {:ok, %{status_code: 201}} -> payment
      _ -> {:error, :payment_not_created}
    end
  end

  def wirecard_order(params) do
    {:ok,
     %{
       "ownId" => params["ownId"],
       "amount" => %{
         "currency" => "BRL",
         "subtotals" => %{
           "shipping" => 1000
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

  def create_pedido(items, cliente, order) do
    case pedido_params(items, cliente, order) do
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
      _ -> "N"
    end
  end

  def pedido_params(items, cliente, order) do
    pedido = %{
      "client_id" => cliente.id,
      "order_id" => verify_type("A", order),
      "filial" => "",
      "numero" => "",
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
      "produto" => items["produto"],
      "quantidade" => items["quantidade"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "tests" => formatting_test(items["tests"]),
      "prc_unitario" => items["prc_unitario"],
      "olho" => "D",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
      "esferico" => map[olho]["degree"],
      "cilindrico" => map[olho]["cylinder"],
      "eixo" => map[olho]["axis"],
      "cor" => map[olho]["cor"],
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map[olho]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => String.slice(Ecto.UUID.autogenerate(), 0..10)
    }
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
      "olho" => "E",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
      "esferico" => map[olho]["degree"],
      "cilindrico" => map[olho]["cylinder"],
      "eixo" => map[olho]["axis"],
      "cor" => map[olho]["cor"],
      "adc_padrao" => items["adc_padrao"],
      "adicao" => map[olho]["adicao"],
      "nota_fiscal" => items["nota_fiscal"],
      "serie_nf" => items["serie_nf"],
      "num_pedido" => items["num_pedido"],
      "url_image" => "http://portal.centraloftalmica.com/images/#{items["grupo"]}.jpg",
      "grupo" => items["grupo"],
      "codigo_item" => String.slice(Ecto.UUID.autogenerate(), 0..10)
    }
  end

  def olho_diferentes_D(items, map) do
    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
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
      "olho" => "D",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
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
      "codigo_item" => items["codigo_item"]
    }
  end

  def olho_diferentes_E(items, map) do
    %{
      "tipo_venda" => map["type"],
      "pedido_de_venda_id" => 1,
      "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
      "filial" => items["filial"],
      "operation" => map["operation"],
      "codigo" => items["codigo"],
      "nocontrato" => items["nocontrato"],
      "produto" => items["produto"],
      "tests" => formatting_test(items["tests"]),
      "quantidade" => items["quantidade"],
      "paciente" => map["paciente"]["nome"],
      "num_pac" => map["paciente"]["numero"],
      "dt_nas_pac" => map["paciente"]["data_nascimento"],
      "prc_unitario" => items["prc_unitario"],
      "olho" => "E",
      "virtotal" => items["quantidade"] * items["prc_unitario"],
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
      "codigo_item" => items["codigo_item"]
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
        "ownId" => cliente.codigo,
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

  def payment_params({:ok, cartao = %CartaoSchema{}}) do
    %{
      "installmentCount" => 1,
      "statementDescriptor" => "central",
      "fundingInstrument" => %{
        "method" => "CREDIT_CARD",
        "creditCard" => %{
          "expirationYear" => String.slice(cartao.ano_validade, 2..3),
          "expirationMonth" => cartao.mes_validade,
          "number" => cartao.cartao_number,
          "cvc" => "123",
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

  def get_cliente_by_id(id) do
    case Repo.get_by(ClientesSchema, id: id) do
      nil -> :error
      cliente -> {:ok, cliente}
    end
  end

  def items_order(items) do
    order_items =
      Enum.flat_map(
        items,
        fn item ->
          Enum.map(item["items"], fn order ->
            %{
              "product" => order["produto"],
              "category" => "OTHER_CATEGORIES",
              "quantity" => order["quantidade"],
              "detail" => "Mais info...",
              "price" => order["prc_unitario"]
            }
          end)
        end
      )

    {:ok, order_items}
  end

  def get_cartao_cliente(id) do
    case Repo.get_by(CartaoSchema, id: id) do
      nil ->
        {:error, :cartao_not_found}

      cartao_cliente ->
        {:ok, cartao_cliente}
    end
  end

  def get_pedidos(cliente_id, filtro) do
    PedidosDeVendaSchema
    |> preload(:items)
    |> where([p], p.client_id == ^cliente_id and p.status_ped == ^filtro)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end

  def create_credito_financeiro(items, cliente, %{"type" => type, "operation" => operation}) do
    case pedido_params(items, cliente, "") do
      {:ok, pedido} ->
        %PedidosDeVendaSchema{}
        |> PedidosDeVendaSchema.changeset(pedido)
        |> Repo.insert()

      _ ->
        {:error, :pedido_failed}
    end
  end

  def get_pedido_id(pedido_id, cliente_id) do
    pedido_id = String.to_integer(pedido_id)

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
end
