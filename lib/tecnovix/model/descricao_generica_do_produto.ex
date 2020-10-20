defmodule Tecnovix.DescricaoGenericaDoProdutoModel do
  use Tecnovix.DAO, schema: Tecnovix.DescricaoGenericaDoProdutoSchema
  alias Tecnovix.Repo
  alias Tecnovix.DescricaoGenericaDoProdutoSchema, as: DescricaoSchema
  import Ecto.Query

  def verify_graus(params) do
    query =
      DescricaoSchema
      |> where(
        [d],
        d.grupo == ^params["group"] and d.cilindrico == ^params["cylinder"] and
          d.eixo == ^params["aixs"] and d.cor == ^params["cor"] and d.adicao == ^params["adicao"] and
          d.esferico == ^params["degree"]
      )
      |> first()
      |> Repo.one()
      |> IO.inspect()

      case query.blo_de_tela do
        1 -> {:ok, false}
        _ -> {:ok, true}
      end
  end

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(data, fn descricao ->
       descricao = Map.put(descricao, "grupo", String.upcase(descricao["grupo"]))

       with nil <-
              Repo.get_by(DescricaoSchema, codigo: descricao["codigo"]) do
         {:ok, create} = create(descricao)
         create
       else
         changeset ->
           {:ok, update} = __MODULE__.update(changeset, descricao)
           update
       end
     end)}
  end

  def insert_or_update(%{"grupo" => grupo, "codigo" => codigo} = params) do
    params = Map.put(params, "grupo", String.upcase(params["grupo"]))

    with nil <- Repo.get_by(DescricaoSchema, codigo: codigo) do
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
      Enum.map(list, fn map -> verify_field(map, field) end)
      |> Enum.uniq()
      |> Enum.sort(:desc)

    {list, Map.put(acc, field, fields)}
  end

  def verify_field(map, field) do
    case field do
      :cor ->
        case Map.get(map, field) do
          nil -> nil
          value -> String.capitalize(value)
        end

      :graus_eixo ->
        Map.get(map, field)

      _ ->
        Decimal.to_float(Map.get(map, field))
    end
  end
end
