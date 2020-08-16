defmodule Tecnovix.CartaoDeCreditoModel do
  use Tecnovix.DAO, schema: Tecnovix.CartaoCreditoClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.CartaoCreditoClienteSchema, as: CreditoSchema
  alias Ecto.Multi
  import Ecto.Query

  def get_cc(%{"cliente_id" => cliente_id}) do
    CreditoSchema
    |> where([c], c.cliente_id == ^cliente_id)
  end

  def create_cc(params = %{"status" => 1}) do
    Multi.new()
    |> Multi.update_all(Ecto.UUID.autogenerate(), get_cc(params), set: [status: 0])
    |> Multi.insert(Ecto.UUID.autogenerate(), CreditoSchema.changeset(%CreditoSchema{}, params))
    |> Repo.transaction()
  end
end
