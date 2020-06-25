defmodule TecnovixWeb.PageControllerTest do
  use TecnovixWeb.ConnCase
  alias Tecnovix.TestHelp

  test "insert or update of the table CLIENTES" do
    params = TestHelp.parse_json("clientes.json")

    data =
      build_conn()
      |> post("/api/sync/clientes", params)
      |> recycle()
      |> post("/api/sync/clientes", params)
      |> json_response(200)

    assert data["cnpj_cpf"] == "11223344556677"
  end

  test "insert or update of the table ATEND_PREF_CLIENTES" do
    params = TestHelp.parse_json("atend_pref_cliente.json")

    data =
      build_conn()
      |> post("/api/sync/atend_pref_cliente", params)
      |> recycle()
      |> post("/api/sync/atend_pref_cliente", params)
      |> json_response(200)

    assert data["cod_cliente"] == "123456"
  end

  test "insert or update of the table CONTAS_A_RECEBER" do
    params = TestHelp.parse_json("contas_a_receber.json")

    data =
      build_conn()
      |> post("/api/sync/contas_a_receber", params)
      |> recycle()
      |> post("/api/sync/contas_a_receber", params)
      |> json_response(200)

    assert data["cliente_id"] == 1
  end

  test "insert or update of the table CONTRATO_DE_PARCERIA" do
    params = TestHelp.parse_json("contrato_de_parceria.json")

    data =
      build_conn()
      |> post("/api/sync/contrato_de_parceria", params)
      |> recycle()
      |> post("/api/sync/contrato_de_parceria", params)
      |> json_response(200)

    assert data["cliente_id"] == 1
  end

  test "insert or update of the table DESCRICAO_GENERICA_DO_PRODUTO" do
    params = TestHelp.parse_json("descricao_generica_do_produto.json")

    data =
      build_conn()
      |> post("/api/sync/descricao_generica_do_produto", params)
      |> recycle()
      |> post("/api/sync/descricao_generica_do_produto", params)
      |> json_response(200)

    assert data["grupo"] == "1234"
  end

  test "insert or update of the table ITENS_DO_CONTRATO_DE_PARCERIA" do
    params = TestHelp.parse_json("itens_do_contrato_parceria.json")

    data =
      build_conn()
      |> post("/api/sync/itens_do_contrato_de_parceria", params)
      |> recycle()
      |> post("/api/sync/itens_do_contrato_de_parceria", params)
      |> json_response(200)

    assert data["filial"] == "1234"
  end

  test "insert or update of the table ITENS_DOS_PEDIDO_DE_VENDA" do
    params = TestHelp.parse_json("itens_dos_pedidos_de_venda.json")

    data =
      build_conn()
      |> post("/api/sync/itens_dos_pedidos_de_venda", params)
      |> recycle()
      |> post("/api/sync/itens_dos_pedidos_de_venda", params)
      |> json_response(200)

    assert data["filial"] == "teste"
  end

  test "insert or update of the table ITENS_PRE_DEVOLUCAO" do
    params = TestHelp.parse_json("itens_pre_devolucao.json")

    data =
      build_conn()
      |> post("/api/sync/itens_pre_devolucao", params)
      |> recycle()
      |> post("/api/sync/itens_pre_devolucao", params)
      |> json_response(200)

    assert data["descricao"] == "Estou escrevendo isso somente para testar!"
  end

  test "insert or update of the table PEDIDOS_DE_VENDA" do
    params = TestHelp.parse_json("pedidos_de_venda.json")

    data =
      build_conn()
      |> post("/api/sync/pedidos_de_venda", params)
      |> recycle()
      |> post("/api/sync/pedidos_de_venda", params)
      |> json_response(200)

    assert data["filial"] == "123"
  end

  test "insert or update of the table PRE_DEVOLUCAO" do
    params = TestHelp.parse_json("pre_devolucao.json")

    data =
      build_conn()
      |> post("/api/sync/pre_devolucao", params)
      |> recycle()
      |> post("/api/sync/pre_devolucao", params)
      |> json_response(200)

    assert data["cod_pre_dev"] == "teste"
  end

  test "insert or update of the table VENDEDORES" do
    params = TestHelp.parse_json("vendedores.json")

    data =
      build_conn()
      |> post("/api/sync/vendedores", params)
      |> recycle()
      |> post("/api/sync/vendedores", params)
      |> json_response(200)

    assert data["codigo"] == "123456"
  end
end
