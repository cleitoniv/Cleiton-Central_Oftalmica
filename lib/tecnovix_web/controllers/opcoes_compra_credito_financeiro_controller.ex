defmodule Tecnovix.OpcoesCompraCreditoFinanceiroController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.OpcoesCompraCreditoFinanceiroModel
  alias Tecnovix.OpcoesCompraCreditoFinanceiroModel

  def create(conn, %{"param" => params}) do
    with {:ok, opcoes} <- OpcoesCompraCreditoFinanceiroModel.create(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: opcoes})
    end
  end
end
