defmodule Tecnovix.VendedoresModel do
  use Tecnovix.DAO, schema: Tecnovix.VendedoresSchema
  alias Tecnovix.Repo
  alias Tecnovix.VendedoresSchema
  alias TecnovixWeb.Auth.FirebaseVendedor

  def create(params) do
    params =
      Map.put(params, "cnpj_cpf", format_params(params["cnpj_cpf"]))
      |> Map.put("ddd", format_ddd(params["telefone"]))
      |> Map.put("telefone", format_telefone(params["telefone"]))
      # |> Map.put("data_nascimento", format_params(params["data_nascimento"]))

    %VendedoresSchema{}
    |> VendedoresSchema.changeset(params)
    |> Repo.insert()
  end

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

  def format_params(params) do
    params
    |> String.replace("-", "")
    |> String.replace(" ", "")
    |> String.replace("/", "")
    |> String.replace(".", "")
  end

  def format_telefone(telefone) do
    telefone
    |> String.replace("-", "")
    |> String.replace(" ", "")
    |> String.slice(2..11)
  end

  def format_ddd(telefone) do
    telefone
    |> String.replace("-", "")
    |> String.replace(" ", "")
    |> String.slice(0..1)
  end

  def search_register_email(email) do
    case Repo.get_by(VendedoresSchema, email: email) do
      nil ->
        {:error, :not_found}

      usuario ->
        {:ok, usuario}
    end
  end
end
