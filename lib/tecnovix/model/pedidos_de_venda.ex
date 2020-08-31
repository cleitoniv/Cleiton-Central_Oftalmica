defmodule Tecnovix.PedidosDeVendaModel do
  use Tecnovix.DAO, schema: Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Repo
  alias Tecnovix.PedidosDeVendaSchema
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.ClientesSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn pedidos ->
       with nil <-
              Repo.get_by(PedidosDeVendaSchema,
                filial: pedidos["filial"],
                numero: pedidos["numero"]
              ) do
         create(pedidos)
       else
         changeset ->
           Repo.preload(changeset, :items)
           |> __MODULE__.update(pedidos)
       end
     end)}
  end

  def insert_or_update(%{"filial" => filial, "numero" => numero} = params) do
    with nil <- Repo.get_by(PedidosDeVendaSchema, filial: filial, numero: numero) do
      __MODULE__.create(params)
    else
      pedido ->
        {:ok, pedido}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def order(items, cliente) do
    order =
      cliente
      |> CartaoModel.order_params(items)
      |> PedidosDeVendaModel.wirecard_order()
      |> Wirecard.create_order()

    case order do
      {:ok, %{status_code: 201}} -> order
      _ -> {:error, :order_not_created}
    end
  end

  def payment(%{"id_cartao" => cartao_id}, order) do
    order = Jason.decode!(order.body)
    order_id = order["id"]

    payment =
      cartao_id
      |> CartaoModel.get_cartao_cliente()
      |> CartaoModel.payment_params()
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

  def pedido_params(items, cliente, order) do
    {:ok,
     %{
       "client_id" => cliente.id,
       "order_id" => Jason.decode!(order.body)["order"]["id"],
       "filial" => "",
       "numero" => "",
       "cliente" => cliente.codigo,
       "tipo_venda" => "",
       "pd_correios" => "",
       "vendedor_1" => "",
       "status_ped" => 0,
       "items" =>
         Enum.reduce(items, [], fn item, acc ->
           array =
             Enum.map(item["items"], fn items ->
               %{
                 "pedido_de_venda_id" => 1,
                 "descricao_generica_do_produto_id" => items["descricao_generica_do_produto_id"],
                 "filial" => items["filial"],
                 "nocontrato" => items["nocontrato"],
                 "produto" => items["produto"],
                 "quantidade" => items["quantidade"],
                 "prc_unitario" => items["prc_unitario"],
                 "olho" => items["olho"],
                 "paciente" => items["nome"],
                 "num_pac" => items["numero"],
                 "dt_nas_pac" => items["data_nascimento"],
                 "virtotal" => items["virtotal"],
                 "esferico" => items["esferico"],
                 "cilindrico" => items["cilindrico"],
                 "eixo" => items["eixo"],
                 "cor" => items["cor"],
                 "adc_padrao" => items["adc_padrao"],
                 "adicao" => items["adicao"],
                 "nota_fiscal" => items["nota_fiscal"],
                 "serie_nf" => items["serie_nf"],
                 "num_pedido" => items["num_pedido"]
               }
             end)

           array ++ acc
         end)
     }}
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
end
