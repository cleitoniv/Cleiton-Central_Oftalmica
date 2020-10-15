defmodule TecnovixWeb.InsertOrUpdate do
  use TecnovixWeb.ConnCase
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Support.Generator
  alias Tecnovix.Repo

  test "insert or update of the table CLIENTES" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_clientes.json")
    multi_param = TestHelp.multi_json("multi_clientes.json")
    multi_param = %{"data" => multi_param}
    # single insert
    single =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/clientes", single_param)
      |> json_response(200)

    # multi insert
    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/clientes", multi_param)
      |> json_response(200)
      |> IO.inspect()

    assert single["success"] == true
    assert multi["success"] == true
  end

  test "insert or update of the table ATEND_PREF_CLIENTES" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_atend_pref_cliente.json")
    multi_param = TestHelp.multi_json("multi_atend_pref_cliente.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/atend_pref_cliente", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/atend_pref_cliente", multi_param)
    |> json_response(200)

    IO.inspect(Tecnovix.Repo.all(Tecnovix.AtendPrefClienteSchema))
  end

  test "insert or update of the table CONTAS_A_RECEBER" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_contas_a_receber.json")
    multi_param = TestHelp.multi_json("multi_contas_a_receber.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/contas_a_receber", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/contas_a_receber", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table CONTRATO_DE_PARCERIA" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_contrato_de_parceria.json")
    multi_param = TestHelp.multi_json("multi_contrato_de_parceria.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/contrato_de_parceria", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/contrato_de_parceria", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table DESCRICAO_GENERICA_DO_PRODUTO" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_descricao_generica_do_produto.json")
    multi_param = TestHelp.multi_json("multi_descricao_generica_do_produto.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/descricao_generica_do_produto", single_param)
    |> recycle()
    |> post("/api/sync/descricao_generica_do_produto", Map.put(single_param, "grupo", "dsa"))
    |> json_response(200)

    IO.inspect(Tecnovix.Repo.all(Tecnovix.DescricaoGenericaDoProdutoSchema))
  end

  test "insert or update of the table ITENS_DO_CONTRATO_DE_PARCERIA" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_itens_do_contrato_parceria.json")
    multi_param = TestHelp.multi_json("multi_itens_do_contrato_parceria.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_do_contrato_de_parceria", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_do_contrato_de_parceria", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table ITENS_DOS_PEDIDO_DE_VENDA" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_itens_dos_pedidos_de_venda.json")
    multi_param = TestHelp.multi_json("multi_itens_dos_pedidos_de_venda.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_dos_pedidos_de_venda", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_dos_pedidos_de_venda", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table ITENS_PRE_DEVOLUCAO" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_itens_pre_devolucao.json")
    multi_param = TestHelp.multi_json("multi_itens_pre_devolucao.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_pre_devolucao", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/itens_pre_devolucao", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table PEDIDOS_DE_VENDA" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_pedidos_and_items.json")
    multi_param = TestHelp.multi_json("multi_pedidos_and_items.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pedidos_de_venda", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/pedidos_de_venda", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table PRE_DEVOLUCAO" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_pre_devolucao.json")
    multi_param = TestHelp.multi_json("multi_pre_devolucao.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pre_devolucao", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/pre_devolucao", multi_param)
    |> json_response(200)
  end

  test "insert or update of the table VENDEDORES" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_param = TestHelp.single_json("single_vendedores.json")
    multi_param = TestHelp.multi_json("multi_vendedores.json")
    multi_param = %{"data" => multi_param}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/vendedores", single_param)
    |> recycle()
    |> Generator.put_auth(token)
    |> post("/api/sync/vendedores", multi_param)
    |> json_response(200)
  end

  test "cast assoc pedidos de venda e pre devolucao" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    single_pedido = TestHelp.single_json("single_pedidos_and_items.json")
    single_devolucao = TestHelp.single_json("single_devolucao_and_items.json")
    single_contrato = TestHelp.single_json("single_contrato_and_items.json")
    multi_pedido = TestHelp.multi_json("multi_pedidos_and_items.json")
    multi_pedido = %{"data" => multi_pedido}
    multi_devolucao = TestHelp.multi_json("multi_devolucao_and_items.json")
    multi_devolucao = %{"data" => multi_devolucao}
    multi_contrato = TestHelp.multi_json("multi_contrato_and_items.json")
    multi_contrato = %{"data" => multi_contrato}

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pedidos_de_venda", single_pedido)
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pedidos_de_venda", multi_pedido)
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pre_devolucao", single_devolucao)
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/pre_devolucao", multi_devolucao)
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/contrato_de_parceria", single_contrato)
    |> json_response(200)

    build_conn()
    |> Generator.put_auth(token)
    |> post("/api/sync/contrato_de_parceria", multi_contrato)
    |> json_response(200)
  end
end
