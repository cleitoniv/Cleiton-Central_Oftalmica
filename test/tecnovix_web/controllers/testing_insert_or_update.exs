defmodule TecnovixWeb.InsertOrUpdate do
  use TecnovixWeb.ConnCase
  alias Tecnovix.TestHelp

  test "insert or update of the table CLIENTES" do
    single_param = TestHelp.single_json("single_clientes.json")
    multi_param = TestHelp.multi_json("multi_clientes.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/clientes", single_param)
      |> recycle()
      |> post("/api/sync/clientes", multi_param)
      |> json_response(200)
      |> IO.inspect
  end

  test "insert or update of the table ATEND_PREF_CLIENTES" do
    single_param = TestHelp.single_json("single_atend_pref_cliente.json")
    multi_param =  TestHelp.multi_json("multi_atend_pref_cliente.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/atend_pref_cliente", single_param)
      |> recycle()
      |> post("/api/sync/atend_pref_cliente", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table CONTAS_A_RECEBER" do
    single_param = TestHelp.single_json("single_contas_a_receber.json")
    multi_param = TestHelp.multi_json("multi_contas_a_receber.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/contas_a_receber", single_param)
      |> recycle()
      |> post("/api/sync/contas_a_receber", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table CONTRATO_DE_PARCERIA" do
    single_param = TestHelp.single_json("single_contrato_de_parceria.json")
    multi_param = TestHelp.multi_json("multi_contrato_de_parceria.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/contrato_de_parceria", single_param)
      |> recycle()
      |> post("/api/sync/contrato_de_parceria", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table DESCRICAO_GENERICA_DO_PRODUTO" do
    single_param = TestHelp.single_json("single_descricao_generica_do_produto.json")
    multi_param = TestHelp.multi_json("multi_descricao_generica_do_produto.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/descricao_generica_do_produto", single_param)
      |> recycle()
      |> post("/api/sync/descricao_generica_do_produto", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table ITENS_DO_CONTRATO_DE_PARCERIA" do
    single_param = TestHelp.single_json("single_itens_do_contrato_parceria.json")
    multi_param = TestHelp.multi_json("multi_itens_do_contrato_parceria.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/itens_do_contrato_de_parceria", single_param)
      |> recycle()
      |> post("/api/sync/itens_do_contrato_de_parceria", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table ITENS_DOS_PEDIDO_DE_VENDA" do
    single_param = TestHelp.single_json("single_itens_dos_pedidos_de_venda.json")
    multi_param = TestHelp.multi_json("multi_itens_dos_pedidos_de_venda.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/itens_dos_pedidos_de_venda", single_param)
      |> recycle()
      |> post("/api/sync/itens_dos_pedidos_de_venda", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table ITENS_PRE_DEVOLUCAO" do
    single_param = TestHelp.single_json("single_itens_pre_devolucao.json")
    multi_param = TestHelp.multi_json("multi_itens_pre_devolucao.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/itens_pre_devolucao", single_param)
      |> recycle()
      |> post("/api/sync/itens_pre_devolucao", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table PEDIDOS_DE_VENDA" do
    single_param = TestHelp.single_json("single_pedidos_de_venda.json")
    multi_param = TestHelp.multi_json("multi_pedidos_de_venda.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/pedidos_de_venda", single_param)
      |> recycle()
      |> post("/api/sync/pedidos_de_venda", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table PRE_DEVOLUCAO" do
    single_param = TestHelp.single_json("single_pre_devolucao.json")
    multi_param = TestHelp.multi_json("multi_pre_devolucao.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/pre_devolucao", single_param)
      |> recycle()
      |> post("/api/sync/pre_devolucao", multi_param)
      |> json_response(200)
  end

  test "insert or update of the table VENDEDORES" do
    single_param = TestHelp.single_json("single_vendedores.json")
    multi_param = TestHelp.multi_json("multi_vendedores.json")
    multi_param = %{"data" => multi_param}

      build_conn()
      |> post("/api/sync/vendedores", single_param)
      |> recycle()
      |> post("/api/sync/vendedores", multi_param)
      |> json_response(200)
  end
end
