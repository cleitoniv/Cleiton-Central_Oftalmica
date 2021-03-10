defmodule Tecnovix.VendedoresModel do
  use Tecnovix.DAO, schema: Tecnovix.VendedoresSchema
  alias Tecnovix.Repo
  alias Tecnovix.VendedoresSchema
  alias TecnovixWeb.Auth.FirebaseVendedor

  def insert_or_update(%{"cnpj_cpf" => cnpj_cpf} = params) do
    case Repo.get_by(VendedoresSchema, cnpj_cpf: cnpj_cpf) do
      nil ->
        with false <- email_exist(params["email"]),
             {:ok, _seller} <- create(params),
             {:ok, %{status_code: 200}} <-
               FirebaseVendedor.create_user(%{
                 email: params["email"],
                 password: params["password"]
               }) do
        else
          true -> {:error, :email_invalid}
          error -> error
        end

      vendedor ->
        {:ok, vendedor}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def email_exist(email) do
    case Repo.get_by(VendedoresSchema, email: email) do
      nil -> false
      _ -> true
    end
  end
end
