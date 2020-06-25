defmodule TecnovixWeb.Router do
  use TecnovixWeb, :router
  import TecnovixWeb.Auth.SyncUsers

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user do
    plug :sync_users_auth
  end

  scope "/", TecnovixWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    post "/sync/clientes", TecnovixWeb.ClientesController, :insert_or_update
    post "/sync/atend_pref_cliente", TecnovixWeb.AtendPrefClienteController, :insert_or_update
    post "/sync/contas_a_receber", TecnovixWeb.ContasAReceberController, :insert_or_update
    post "/sync/contrato_de_parceria", TecnovixWeb.ContratoDeParceriaController, :insert_or_update

    post "/sync/descricao_generica_do_produto",
         TecnovixWeb.DescricaoGenericaDoProdutoController,
         :insert_or_update

    post "/sync/itens_do_contrato_de_parceria",
         TecnovixWeb.ItensDoContratoDeParceriaController,
         :insert_or_update

    post "/sync/itens_dos_pedidos_de_venda",
         TecnovixWeb.ItensDosPedidosDeVendaController,
         :insert_or_update

    post "/sync/itens_pre_devolucao", TecnovixWeb.ItensPreDevolucaoController, :insert_or_update
    post "/sync/pedidos_de_venda", TecnovixWeb.PedidosDeVendaController, :insert_or_update
    post "/sync/pre_devolucao", TecnovixWeb.PreDevolucaoController, :insert_or_update
    post "/sync/vendedores", TecnovixWeb.VendedoresController, :insert_or_update

    forward "/api", Absinthe.Plug, schema: TecnovixWeb.Graphql.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TecnovixWeb.Graphql.Schema,
      interface: :simple
  end
end
