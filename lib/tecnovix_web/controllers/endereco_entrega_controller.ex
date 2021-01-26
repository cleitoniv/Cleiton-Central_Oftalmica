defmodule Tecnovix.EnderecoEntregaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.EnderecoEntregaModel
  alias Tecnovix.EnderecoEntregaModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, endereco} <- EnderecoEntregaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: endereco})
    else
      {:error, %Ecto.Changeset{} = error} -> {:error, error}
      _ -> {:error, :invalid_parameter}
    end
  end
end
