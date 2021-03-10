defmodule TecnovixWeb.VendedoresController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.VendedoresModel
  alias Tecnovix.VendedoresModel
  alias TecnovixWeb.Auth.FirebaseVendedor

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, vendedor} <- VendedoresModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("vendedores.json", %{item: vendedor})
    end
  end

  def current_seller(conn, _params) do
    {:ok, seller} = conn.private.auth

    conn
    |> put_status(200)
    |> put_resp_content_type("application/json")
    |> render("vendedores.json", %{item: seller})
  end

  def create(conn, %{"param" => params}) do
    with false <- VendedoresModel.email_exist(params["email"]),
         {:ok, seller} <- VendedoresModel.create(params),
         {:ok, %{status_code: 200}} <-
           FirebaseVendedor.create_user(%{email: params["email"], password: params["password"]}) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("vendedores.json", %{item: seller})
    else
      true -> {:error, :email_invalid}
      error -> error
    end
  end
end
