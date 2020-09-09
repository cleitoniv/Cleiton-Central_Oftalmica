defmodule Tecnovix.OpcoesCompraCreditoFinanceiroModel do
  use Tecnovix.DAO, schema: Tecnovix.OpcoesCompraCreditoFinanceiroSchema
  alias Tecnovix.OpcoesCompraCreditoFinanceiroSchema, as: OpcoesCredito
  alias Tecnovix.Repo
  
  def get_offers() do
    Repo.all(OpcoesCredito)
  end
end
