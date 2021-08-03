defmodule Tecnovix.EnderecoEntregaModel do
  use Tecnovix.DAO, schema: Tecnovix.EnderecoEntregaSchema
  alias Tecnovix.EnderecoEntregaSchema
  alias Tecnovix.Repo

  def create(params) do
    case is_nil(params["cep_entrega"]) do
      true ->
        {:ok, %{}}

      false ->
        %EnderecoEntregaSchema{}
        |> EnderecoEntregaSchema.changeset(params)
        |> Repo.insert()
    end
  end

  def insert_or_update(%{"cliente_id" => cliente_id} = params) do
    with nil <- Repo.get_by(EnderecoEntregaSchema, cliente_id: cliente_id) do
      __MODULE__.create(params)
    else
      cliente ->
        __MODULE__.update(cliente, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
