defmodule Tecnovix.OpcoesCompraCreditoFinanceiroModel do
  use Tecnovix.DAO, schema: Tecnovix.OpcoesCompraCreditoFinanceiroSchema
  alias Tecnovix.OpcoesCompraCreditoFinanceiroSchema, as: OpcoesCredito
  alias Tecnovix.Repo

  def get_offers() do
    Repo.all(OpcoesCredito)
    |> Enum.map(fn credito ->
      desconto = credito.valor * (credito.desconto / 100)

      credito.valor - desconto
    end)
  end
end
