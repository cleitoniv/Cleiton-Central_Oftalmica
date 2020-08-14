defmodule Tecnovix.Test.Wirecard do
  use TecnovixWeb.ConnCase, async: false
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Resource.Wirecard.Actions
  alias TecnovixWeb.CartaoController
  alias Tecnovix.TestHelper

  test "Criando a order do wirecard" do
    wirecard_cliente = Generator.wirecard_cliente_param
    params = Generator.cartao_cliente()

    build_conn
    |> CartaoController.create_cc(params, wirecard_cliente)
    |> IO.inspect
  end
end
