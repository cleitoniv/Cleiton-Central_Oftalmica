defmodule Tecnovix.AtendPrefClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.AtendPrefClienteSchema

  alias Tecnovix.Repo
  alias Tecnovix.AtendPrefClienteSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    multi =
      Enum.reduce(params["data"], Multi.new(), fn atend_pref, multi ->
        with nil <- Repo.get_by(AtendPrefClienteSchema, cod_cliente: atend_pref["cod_cliente"]),
             nil <- Repo.get_by(AtendPrefClienteSchema, loja_cliente: atend_pref["loja_cliente"]) do
           multi
           |> Multi.insert(Ecto.UUID.autogenerate(), AtendPrefClienteSchema.changeset(%AtendPrefClienteSchema{}, atend_pref))
        else
          changeset ->
            multi
            |> Multi.update(Ecto.UUID.autogenerate(), AtendPrefClienteSchema.changeset(changeset, atend_pref))
        end
      end)
      Repo.transaction(multi)
  end

  def insert_or_update(%{"cod_cliente" => cod_cliente, "loja_cliente" => loja_cliente} = params) do
    with nil <- Repo.get_by(AtendPrefClienteSchema, cod_cliente: cod_cliente),
         nil <- Repo.get_by(AtendPrefClienteSchema, loja_cliente: loja_cliente) do
      create(params)
    else
      atend_pref ->
        {:ok, atend_pref}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def create(params, cliente_id) do
    case __MODULE__.get_by(cliente_id: cliente_id) do
      nil -> __MODULE__.create(params)
      atend_pref -> __MODULE__.update(atend_pref, params)
    end
  end
end
