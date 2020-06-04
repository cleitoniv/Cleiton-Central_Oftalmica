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

    resources "/user",  TecnovixWeb.SyncUsersController, only: [:create]
    post "/login", TecnovixWeb.SyncUsersController, :login
    pipe_through :user
    post "/teste", TecnovixWeb.SyncUsersController, :run

    forward "/api", Absinthe.Plug, schema: TecnovixWeb.Graphql.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TecnovixWeb.Graphql.Schema,
      interface: :simple
  end
end
