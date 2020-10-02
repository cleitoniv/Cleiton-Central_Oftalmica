defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema
  import Ecto.Query

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(data, fn descricao ->
       descricao = Map.put(descricao, "grupo", String.upcase(descricao["grupo"]))

       with nil <-
              Repo.get_by(DescricaoSchema, grupo: descricao["grupo"], codigo: descricao["codigo"]) do
         create(descricao)
       else
         changeset ->
          {:ok, update} = __MODULE__.update(changeset, descricao)
          update
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

  def get_graus(grupo) do
    graus =
      DescricaoSchema
      |> where([d], ^grupo == d.grupo)
      |> select([d], %{
        graus_esferico: d.esferico,
        graus_cilindrico: d.cilindrico,
        graus_eixo: d.eixo,
        graus_adicao: d.adicao,
        cor: d.cor
      })
      |> Repo.all()

    parse_fields({graus, %{}}, :graus_esferico)
    |> parse_fields(:graus_cilindrico)
    |> parse_fields(:graus_eixo)
    |> parse_fields(:graus_adicao)
    |> parse_fields(:cor)
  end

  def parse_fields({list, acc}, field) do
    fields =
      Enum.map(list, fn map -> Map.get(map, field) end)
      |> Enum.uniq()
      |> Enum.sort(:desc)

    {list, Map.put(acc, field, fields)}
  end
end
