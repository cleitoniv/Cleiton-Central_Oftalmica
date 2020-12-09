defmodule Tecnovix.AtendPrefClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.AtendPrefClienteSchema

  alias Tecnovix.Repo
  alias Tecnovix.AtendPrefClienteSchema

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn atend_pref ->
       with nil <-
              Repo.get_by(AtendPrefClienteSchema,
                cod_cliente: atend_pref["cod_cliente"],
                loja_cliente: atend_pref["loja_cliente"]
              ) do
         create(atend_pref)
       else
         changeset ->
           __MODULE__.update(changeset, atend_pref)
       end
     end)}
  end

  def insert_or_update(%{"cod_cliente" => cod_cliente, "loja_cliente" => loja_cliente} = params) do
    with nil <-
           Repo.get_by(AtendPrefClienteSchema,
             cod_cliente: cod_cliente,
             loja_cliente: loja_cliente
           ) do
      create(params)
    else
      atend_pref ->
        __MODULE__.update(atend_pref, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def formatting_atend(params, cliente) do
    dia_remessa =
      case cliente.dia_remessa do
        nil -> "-"
        "1" -> "segunda-feira"
        "2" -> "terça-feira"
        "3" -> "quarta-feira"
        "4" -> "quinta-feira"
        "5" -> "sexta-feira"
      end

    case params["horario"] do
      "Manhã" ->
        horario = String.downcase(params["horario"])

        {dia, _} = String.split_at(dia_remessa, 3)

        horario_new = "#{dia}_#{horario}"

        atend =
          Map.new()
          |> Map.put(horario_new, 1)
          |> Map.put("cod_cliente", cliente.codigo)
          |> Map.put("loja_cliente", cliente.loja)
          |> Map.put("cliente_id", cliente.id)

        case Repo.get_by(AtendPrefClienteSchema, cliente_id: cliente.id) do
          nil ->
            create(atend)

          changeset ->
            previous =
              Enum.flat_map(Map.from_struct(changeset), fn {key, value} ->
                case value == 1 and key != :id do
                  true -> [key]
                  false -> []
                end
              end)
              |> Enum.at(0)

            atend = Map.put(atend, "#{previous}", 0)
            update(changeset, atend)
        end

      "Tarde" ->
        horario = String.downcase(params["horario"])

        {dia, _} = String.split_at(dia_remessa, 3)

        horario_new = "#{dia}_#{horario}"

        atend =
          Map.new()
          |> Map.put(horario_new, 1)
          |> Map.put("cod_cliente", cliente.codigo)
          |> Map.put("loja_cliente", cliente.loja)
          |> Map.put("cliente_id", cliente.id)

        case Repo.get_by(AtendPrefClienteSchema, cliente_id: cliente.id) do
          nil ->
            create(atend)

          changeset ->
            previous =
              Enum.flat_map(Map.from_struct(changeset), fn {key, value} ->
                case value == 1 and key != :id do
                  true -> [key]
                  false -> []
                end
              end)
              |> Enum.at(0)

            atend = Map.put(atend, "#{previous}", 0)
            update(changeset, atend)
        end

      _ ->
      horario = "manhã"

      {dia, _} = String.split_at(dia_remessa, 3)

      horario_new = "#{dia}_#{horario}"

      atend =
        Map.new()
        |> Map.put(horario_new, 1)
        |> Map.put("cod_cliente", cliente.codigo)
        |> Map.put("loja_cliente", cliente.loja)
        |> Map.put("cliente_id", cliente.id)

      case Repo.get_by(AtendPrefClienteSchema, cliente_id: cliente.id) do
        nil ->
          create(atend)

        changeset ->
          previous =
            Enum.flat_map(Map.from_struct(changeset), fn {key, value} ->
              case value == 1 and key != :id do
                true -> [key]
                false -> []
              end
            end)
            |> Enum.at(0)

          atend = Map.put(atend, "#{previous}", 0)
          update(changeset, atend)
      end

      horario = "tarde"

      {dia, _} = String.split_at(dia_remessa, 3)

      horario_new = "#{dia}_#{horario}"

      atend =
        Map.new()
        |> Map.put(horario_new, 1)
        |> Map.put("cod_cliente", cliente.codigo)
        |> Map.put("loja_cliente", cliente.loja)
        |> Map.put("cliente_id", cliente.id)

      case Repo.get_by(AtendPrefClienteSchema, cliente_id: cliente.id) do
        nil ->
          create(atend)

        changeset ->
          previous =
            Enum.flat_map(Map.from_struct(changeset), fn {key, value} ->
              case value == 1 and key != :id do
                true -> [key]
                false -> []
              end
            end)
            |> Enum.at(0)

          atend = Map.put(atend, "#{previous}", 0)
          update(changeset, atend)
      end
    end
  end
end
