defmodule Tecnovix.ClientesModel do
  use Tecnovix.DAO, schema: Tecnovix.ClientesSchema
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema
  import Ecto.Changeset

  def create(params) do
    %ClientesSchema{}
    # |> change(%{})
    # |> put_change(:uid, conn.private.auth)
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
    |> String.replace(".", "") end)
  end

  defp formatting_cnpj_cpf(changeset) do
    update_change(changeset, :cnpj_cpf, fn cnpj_cpf ->
    String.replace(cnpj_cpf, "-", "")
    |> String.replace(".", "") end)
  end

  defp formatting_cep(changeset) do
    update_change(changeset, :cep, fn cep ->
    String.replace(cep, "-", "")
    |> String.replace(".", "") end)
  end
end
