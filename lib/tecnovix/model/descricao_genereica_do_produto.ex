defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(data, %{}, fn descricao, _acc ->
      with nil <-
             Repo.get_by(DescricaoSchema, grupo: descricao["grupo"], codigo: descricao["codigo"]) do
        create(descricao)
      else
        changeset ->
          __MODULE__.update(changeset, descricao)
      end
    end)
  end

  def insert_or_update(%{"grupo" => grupo, "codigo" => codigo} = params) do
    with nil <- Repo.get_by(DescricaoSchema, grupo: grupo, codigo: codigo) do
      __MODULE__.create(params)
    else
      descricao ->
        {:ok, descricao}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
