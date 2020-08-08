defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
      Enum.reduce(params["data"], %{}, fn descricao, _acc ->
        with nil <- Repo.get_by(DescricaoSchema, grupo: descricao["grupo"]),
             nil <- Repo.get_by(DescricaoSchema, codigo: params["codigo"]) do
        create(descricao)
        else
          changeset ->
            __MODULE__.update(changeset, descricao)
        end
     end)
  end

  def insert_or_update(%{"grupo" => grupo, "codigo" => codigo} = params) do
    with nil <- Repo.get_by(DescricaoSchema, grupo: grupo),
         nil <- Repo.get_by(DescricaoSchema, codigo: codigo) do
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
