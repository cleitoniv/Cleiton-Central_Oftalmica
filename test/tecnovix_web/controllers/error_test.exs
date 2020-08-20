defmodule TecnovixWeb.InsertOrUpdate do
  use TecnovixWeb.ConnCase
  alias Tecnovix.TestHelp
  alias TecnovixWeb.Support.Generator

  test "Retorno dos erros na inserção de multi clientes" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_cliente.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/clientes", multi_param)
      |> json_response(200)
  end

  test "Retorno dos erros na inserção de multi atend_cliente" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_atend.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/atend_pref_cliente", multi_param)
      |> json_response(200)
  end

  test "Retorno dos erros na inserção de multi contas_a_receber" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_contas.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/contas_a_receber", multi_param)
      |> json_response(200)
      |> IO.inspect()
  end

  test "Retorno dos erros na inserção de multi contrato de parceria" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_contrato.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/contrato_de_parceria", multi_param)
      |> json_response(200)
  end

  test "Retorno dos erros na inserção de multi descricao generica do produto" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_descricao.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/descricao_generica_do_produto", multi_param)
      |> json_response(200)
      |> IO.inspect()
  end

  test "Retorno dos erros na inserção de multi pedidos de venda" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_pedidos.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/pedidos_de_venda", multi_param)
      |> json_response(200)
  end

  test "Retorno dos erros na inserção de multi pre devolucao" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_devolucao.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/pre_devolucao", multi_param)
      |> json_response(200)
  end

  test "Retorno dos erros na inserção de multi vendedores" do
    %{"access_token" => token} = Generator.sync_user("thiagoboeker", "123456")

    multi_param = TestHelp.error_multi("error_multi_vendedores.json")
    multi_param = %{"data" => multi_param}

    multi =
      build_conn()
      |> Generator.put_auth(token)
      |> post("/api/sync/vendedores", multi_param)
      |> json_response(200)
  end
end
