defmodule Tecnovix.ClientesModel do
  use Tecnovix.DAO, schema: Tecnovix.ClientesSchema
  alias Tecnovix.CartaoCreditoClienteSchema, as: Cartao
  alias Tecnovix.Repo
  import Ecto.Query
  alias Tecnovix.ClientesSchema
  import Ecto.Changeset
  import Ecto.Query

  def formatting_dtnasc(dtnasc) do
    [dia, mes, ano] = String.split(dtnasc, "/")
    "#{ano}-#{mes}-#{dia}"
  end

  def ystapp_filter(params) do
    dynamic([c], c.sit_app == ^params["ystapp"])
  end

  def get_cards(cliente) do
    query =
      from c in Cartao,
        where: c.cliente_id == ^cliente.id

    Repo.all(query)
  end

  def create_first_acess(params) do
    %ClientesSchema{}
    |> ClientesSchema.first_acess(params)
    |> Repo.insert()
  end

  def get_cliente(id) do
    case Repo.get_by(ClientesSchema, id: id) do
      nil -> {:error, :not_found}
      cliente -> {:ok, cliente}
    end
  end

  def get_clientes_app(filtro) do
    clientes =
      ClientesSchema
      |> where([c], c.sit_app == ^filtro)
      |> order_by([c], desc: c.inserted_at)
      |> Repo.all()

    case clientes do
      [] -> {:error, :not_found}
      clientes -> {:ok, clientes}
    end
  end

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn cliente ->
       with nil <- Repo.get_by(ClientesSchema, cnpj_cpf: cliente["cnpj_cpf"]) do
         {:ok, create} = create(cliente)
         create
       else
         changeset ->
           {:ok, update} = __MODULE__.update(changeset, cliente)
           update
       end
     end)}
  end

  def insert_or_update_first_access(%{"cnpj_cpf" => cnpj_cpf} = params) do
    with nil <- Repo.get_by(ClientesSchema, cnpj_cpf: cnpj_cpf) do
      __MODULE__.create(params)
    else
      cliente ->
        {:error,
        %ClientesSchema{}
        |> change(%{})
        |> add_error(:usuario, "Usuario já cadastrado")
        }
    end
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
      |> String.replace(" ", "")
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

  def get_endereco_by_cep(cep) do
    url = "viacep.com.br/ws/#{cep}/json/"

    {:ok, endereco} = HTTPoison.get(url, [{"Content-Type", "application/json"}])
  end
end
