defmodule TecnovixWeb.Router do
  use TecnovixWeb, :router
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
    resources "/user", TecnovixWeb.ClientesController

    scope "/client" do
      pipe_through :guest
      post "/", TecnovixWeb.ClientesController, :create_user
      pipe_through :cliente
      get "/message", TecnovixWeb.ClientesController, :run
      post "/user", TecnovixWeb.UsuariosClienteController, :create_user
    end

    forward "/api", Absinthe.Plug, schema: TecnovixWeb.Graphql.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TecnovixWeb.Graphql.Schema,
      interface: :simple
  end
end
