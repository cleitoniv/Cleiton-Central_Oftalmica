defmodule TecnovixWeb.CreditoFinanceiroController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  def create(conn, %{"param" => params, "id_cartao" => id_cartao}) do
    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          CreditoFinanceiroModel.get_cliente_by_id(usuario.cliente_id)
      end

    items_order = items_order(params)

    with {:ok, order} <- CreditoFinanceiroModel.order(items_order, cliente),
         {:ok, payment} <- CreditoFinanceiroModel.payment(id_cartao, order),
         {:ok, credito} <- CreditoFinanceiroModel.insert(params, order, payment, cliente.id) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: credito})
    end
  end

  def items_order(items) do
    Enum.map(
      items,
      fn order ->
        %{
          "product" => "Credito",
          "category" => "OTHER_CATEGORIES",
          "quantity" => 1,
          "detail" => "Compra de credito financeiro.",
          "price" => convert_price(order["valor"], 1)
        }
      end
    )
  end

  def convert_price(prc_unitario, quantidade) do
    (prc_unitario * 100 * quantidade)
    |> Kernel.trunc()
  end
end
