defmodule Tecnovix.ClientesModel do
  use Tecnovix.DAO, schema: Tecnovix.ClientesSchema
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema
  import Ecto.Changeset
  import Ecto.Query

  def ystapp_filter(params) do
    dynamic([c], c.sit_app == ^params["ystapp"])
  end

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    Enum.reduce(params["data"], %{}, fn cliente, _acc ->
      with nil <- Repo.get_by(ClientesSchema, cnpj_cpf: cliente["cnpj_cpf"]) do
        create(cliente)
      else
        changeset ->
          __MODULE__.update(changeset, cliente)
      end
    end)
  end

  def insert_or_update(%{"cnpj_cpf" => cnpj_cpf} = params) do
    with nil <- Repo.get_by(ClientesSchema, cnpj_cpf: cnpj_cpf) do
      __MODULE__.create(params)
    else
      cliente ->
        __MODULE__.update(cliente, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def create(params) do
    %ClientesSchema{}
    |> ClientesSchema.changeset(params)
    |> formatting_telefone()
    |> formatting_cnpj_cpf()
    |> formatting_cep()
    |> ClientesSchema.validations_fisic_jurid(params)
    |> Repo.insert()
  end

  def verify_sit_app(id) do
    Repo.get_by(ClientesSchema, id: id)
  end

  def search_register_email(email) do
    case Repo.get_by(ClientesSchema, email: email) do
      nil ->
        {:error, :not_found}

      v ->
        {:ok, v}
    end
  end

  defp formatting_telefone(changeset) do
    update_change(changeset, :telefone, fn telefone ->
      String.replace(telefone, "-", "")
      |> String.replace(".", "")
    end)
  end

  defp formatting_cnpj_cpf(changeset) do
    update_change(changeset, :cnpj_cpf, fn cnpj_cpf ->
      String.replace(cnpj_cpf, "-", "")
      |> String.replace(".", "")
    end)
  end

  defp formatting_cep(changeset) do
    update_change(changeset, :cep, fn cep ->
      String.replace(cep, "-", "")
      |> String.replace(".", "")
    end)
  end
end
