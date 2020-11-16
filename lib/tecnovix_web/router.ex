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

  pipeline :usuario_cliente do
    plug :user_cliente_auth
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
    get "/verify_field_cadastrado", TecnovixWeb.ClientesController, :verify_field_cadastrado
    get "/send_sms", TecnovixWeb.ClientesController, :send_sms
    get "/confirmation_code", TecnovixWeb.ClientesController, :confirmation_code
    get "/termo_responsabilidade", TecnovixWeb.ClientesController, :termo_responsabilidade

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
      get "/clientes", TecnovixWeb.ClientesController, :get_clientes_app
      get "/pedidos", TecnovixWeb.PedidosDeVendaController, :get_pedidos
      get "/creditos", TecnovixWeb.CreditoFinanceiroController, :get_creditos
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
      post "/first_access", TecnovixWeb.ClientesController, :first_access
      get "/protheus/products", TecnovixWeb.ProtheusController, :get_product
      get "/protheus/:cnpj_cpf", TecnovixWeb.ProtheusController, :get_cliente
      get "/get_endereco_by_cep", TecnovixWeb.ClientesController, :get_endereco_by_cep
      pipe_through :cliente
      get "/current_user", TecnovixWeb.ClientesController, :current_user
      post "/update_password", TecnovixWeb.ClientesController, :update_password
      get "/", TecnovixWeb.ClientesController, :show
      post "/cliente_user", TecnovixWeb.UsuariosClienteController, :create_user
      post "/pedidos", TecnovixWeb.PedidosDeVendaController, :create
      post "/pedido/credito_financeiro", TecnovixWeb.CreditoFinanceiroController, :create
      get "/produtos", TecnovixWeb.ClientesController, :products
      get "/offers", TecnovixWeb.ClientesController, :offers
      get "/products_credits", TecnovixWeb.ClientesController, :products_credits
      get "/orders", TecnovixWeb.ClientesController, :orders
      get "/cart", TecnovixWeb.ClientesController, :cart
      get "/product/:id", TecnovixWeb.ClientesController, :info_product
      get "/detail_order", TecnovixWeb.ClientesController, :detail_order
      get "/cards", TecnovixWeb.ClientesController, :get_cards
      post "/pre_devolucao", TecnovixWeb.PreDevolucaoController, :create
      post "/card", TecnovixWeb.CartaoCreditoClienteController, :create
      get "/pedido/:id", TecnovixWeb.PedidosDeVendaController, :detail_order_id
      post "/contrato_de_parceria", TecnovixWeb.ContratoDeParceriaController, :create
      get "/payments", TecnovixWeb.ClientesController, :get_payments
      get "/points", TecnovixWeb.ClientesController, :get_mypoints
      get "/notifications", TecnovixWeb.ClientesController, :get_notifications
      get "/product_serie/:num_serie", TecnovixWeb.ClientesController, :get_product_serie
      post "/devolution_continue", TecnovixWeb.ClientesController, :devolution_continue
      post "/next_step", TecnovixWeb.ClientesController, :next_step
      get "/extrato_finan", TecnovixWeb.ClientesController, :get_extrato_finan
      get "/extrato_prod", TecnovixWeb.ClientesController, :get_extrato_prod
      get "/send_email_dev", TecnovixWeb.ClientesController, :get_and_send_email_dev
      post "/add_points", TecnovixWeb.PointsController, :add_points
      get "/convert_points", TecnovixWeb.ClientesController, :convert_points
      post "/rescue_points", TecnovixWeb.RescuePointsController, :rescue_points
      post "/atend_pref", TecnovixWeb.AtendPrefClienteController, :get_and_crud_atendimento
      get "/endereco_entrega", TecnovixWeb.ClientesController, :get_endereco_entrega
      get "/get_graus", TecnovixWeb.ClientesController, :get_graus
      put "/read_notification/:id", TecnovixWeb.NotificacoesController, :read_notification
      get "/verify_graus", TecnovixWeb.DescricaoGenericaDoProdutoController, :verify_graus
      get "/revisao", TecnovixWeb.PedidosDeVendaController, :pacientes_revisao

      post "/verify_graus",
           TecnovixWeb.DescricaoGenericaDoProdutoController,
           :verify_graus_olhos_diferentes

      put "/select_card/:id", TecnovixWeb.CartaoCreditoClienteController, :select_card
      post "/pedido_boleto", TecnovixWeb.PedidosDeVendaController, :create_boleto
      get "/generate_boleto", TecnovixWeb.ProtheusController, :generate_boleto
      delete "/card_delete/:id", TecnovixWeb.CartaoCreditoClienteController, :delete_card
      get "/taxa", TecnovixWeb.PedidosDeVendaController, :taxa
      post "/taxa_entrega", TecnovixWeb.PedidosDeVendaController, :taxa_entrega
    end

    forward "/api", Absinthe.Plug, schema: TecnovixWeb.Graphql.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TecnovixWeb.Graphql.Schema,
      interface: :simple
  end
end
