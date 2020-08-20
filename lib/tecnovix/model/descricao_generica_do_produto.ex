defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(data, fn descricao ->
       with nil <-
              Repo.get_by(DescricaoSchema, grupo: descricao["grupo"], codigo: descricao["codigo"]) do
         create(descricao)
       else
         changeset ->
           __MODULE__.update(changeset, descricao)
       end
     end)}
  end

  def insert_or_update(%{"grupo" => grupo, "codigo" => codigo} = params) do
    with nil <- Repo.get_by(DescricaoSchema, grupo: grupo, codigo: codigo) do
      __MODULE__.create(params)
    else
      changeset ->
        __MODULE__.update(changeset, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
