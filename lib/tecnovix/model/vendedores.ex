defmodule Tecnovix.VendedoresModel do
  use Tecnovix.DAO, schema: Tecnovix.VendedoresSchema
  alias Tecnovix.Repo
  alias Tecnovix.VendedoresSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
      Enum.reduce(params["data"], %{}, fn vendedores, _acc ->
        with nil <- Repo.get_by(VendedoresSchema, cnpj_cpf: vendedores["cnpj_cpf"]) do
          create(vendedores)
        else
          changeset ->
          __MODULE__.update(changeset, vendedores)
        end
      end)
  end

  def insert_or_update(%{"cnpj_cpf" => cnpj_cpf} = params) do
    case Repo.get_by(VendedoresSchema, cnpj_cpf: cnpj_cpf) do
      nil ->
        __MODULE__.create(params)

      vendedor ->
        {:ok, vendedor}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
