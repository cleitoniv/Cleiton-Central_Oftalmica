defmodule TecnovixWeb.Router do
  use TecnovixWeb, :router
  import TecnovixWeb.Auth.SyncUsers
  import TecnovixWeb.Auth.Firebase

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

  pipeline :user_sync do
    plug :sync_users_auth
  end

  pipeline :cliente do
    plug :cliente_auth
  end

  pipeline :guest do
    plug :firebase_auth
  end

  scope "/", TecnovixWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    post "/user_sync/login", TecnovixWeb.SyncUsersController, :login

    scope "/sync" do
      pipe_through :user_sync

      post "/clientes", TecnovixWeb.ClientesController, :insert_or_update
      post "/atend_pref_cliente", TecnovixWeb.AtendPrefClienteController, :insert_or_update
      post "/contas_a_receber", TecnovixWeb.ContasAReceberController, :insert_or_update
      post "/contrato_de_parceria", TecnovixWeb.ContratoDeParceriaController, :insert_or_update

      post "/descricao_generica_do_produto",
           TecnovixWeb.DescricaoGenericaDoProdutoController,
           :insert_or_update

      post "/itens_do_contrato_de_parceria",
           TecnovixWeb.ItensDoContratoDeParceriaController,
           :insert_or_update

      post "/itens_dos_pedidos_de_venda",
           TecnovixWeb.ItensDosPedidosDeVendaController,
           :insert_or_update

      post "/itens_pre_devolucao", TecnovixWeb.ItensPreDevolucaoController, :insert_or_update
      post "/pedidos_de_venda", TecnovixWeb.PedidosDeVendaController, :insert_or_update
      post "/pre_devolucao", TecnovixWeb.PreDevolucaoController, :insert_or_update
      post "/vendedores", TecnovixWeb.VendedoresController, :insert_or_update
    end

    scope "/atend_pref_cliente" do
      pipe_through :cliente
      get "/:cod_cliente", TecnovixWeb.AtendPrefClienteController, :get_by_cod_cliente
    end

    scope "/usuarios_cliente" do
      pipe_through :cliente

      put "/:id", TecnovixWeb.UsuariosClienteController, :update_users
      delete "/:id", TecnovixWeb.UsuariosClienteController, :delete_users
      get "/", TecnovixWeb.UsuariosClienteController, :cliente_index
    end

    scope "/cliente" do
      pipe_through :guest
      post "/", TecnovixWeb.ClientesController, :create_user
      get "/protheus/:cnpj_cpf", TecnovixWeb.ProtheusController, :get_cliente
      pipe_through :cliente
      get "/", TecnovixWeb.ClientesController, :show
      post "/logs", TecnovixWeb.LogsClienteController, :create_logs
      get "/message", TecnovixWeb.ClientesController, :run
      post "/cliente_user", TecnovixWeb.UsuariosClienteController, :create_user
    end

    forward "/api", Absinthe.Plug, schema: TecnovixWeb.Graphql.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TecnovixWeb.Graphql.Schema,
      interface: :simple
  end
end
