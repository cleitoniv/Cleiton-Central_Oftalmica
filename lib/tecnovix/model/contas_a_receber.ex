defmodule Tecnovix.ContasAReceberModel do
  use Tecnovix.DAO, schema: Tecnovix.ContasAReceberSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContasAReceberSchema
  alias Ecto.Multi

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
      Enum.reduce(params["data"], %{}, fn contas, _acc ->
        with nil <- Repo.get_by(ContasAReceberSchema, filial: contas["filial"]),
             nil <- Repo.get_by(ContasAReceberSchema, no_titulo: contas["no_titulo"]),
             nil <- Repo.get_by(ContasAReceberSchema, cliente: contas["cliente"]),
             nil <- Repo.get_by(ContasAReceberSchema, loja: contas["loja"]) do
          create(contas)
        else
          changeset ->
            __MODULE__.update(changeset, contas)
        end
      end)
  end

  def insert_or_update(
        %{"filial" => filial, "no_titulo" => no_titulo, "cliente" => cliente, "loja" => loja} =
          params
      ) do
    with nil <- Repo.get_by(ContasAReceberSchema, filial: filial),
         nil <- Repo.get_by(ContasAReceberSchema, no_titulo: no_titulo),
         nil <- Repo.get_by(ContasAReceberSchema, cliente: cliente),
         nil <- Repo.get_by(ContasAReceberSchema, loja: loja) do
      __MODULE__.create(params)
    else
      contas ->
        {:ok, contas}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end
end
