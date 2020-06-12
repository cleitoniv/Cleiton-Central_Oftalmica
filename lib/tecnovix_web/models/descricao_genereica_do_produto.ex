defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema

  def insert_or_update(params) do
    with nil <- Repo.get_by(DescricaoSchema, grupo: params["grupo"]),
         nil <- Repo.get_by(DescricaoSchema, codigo: params["codigo"]) do
          create(params)
    else
      descricao ->
        {:ok, descricao}
    end
  end
end
