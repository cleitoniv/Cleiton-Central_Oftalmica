defmodule Tecnovix.ClientesModel do
  use Tecnovix.DAO, schema: Tecnovix.ClientesSchema
  alias Tecnovix.CartaoCreditoClienteSchema, as: Cartao
  alias Tecnovix.Repo
  import Ecto.Query
  alias Tecnovix.ClientesSchema
  import Ecto.Changeset
  import Ecto.Query

  @sms_token "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkuZGlyZWN0Y2FsbHNvZnQuY29tIiwiYXVkIjoiMTkyLjE2OC4xNS4yNyIsImlhdCI6MTYwMzk5MjAwMCwibmJmIjoxNjAzOTkyMDAwLCJleHAiOjE2MDM5OTU2MDAsImRjdCI6IjMzMDI3NzQwMCIsImNsaWVudF9vYXV0aF9pZCI6IjM3NjA0OSJ9.B4gF3wAeOUkE9GNZSZCHBa8h_6touKQlrXebQrOocpw"
  @header [{"Content-Type", "application/x-www-form-urlencoded"}]

  def create_first_access(params) do
    case Repo.get_by(ClientesSchema, email: params["email"]) do
      %{cadastrado: false} = cliente ->
        update_first_access(cliente, params)

      %{cadastrado: true} ->
        error =
          %ClientesSchema{}
          |> change(%{})
          |> add_error(:email, "Já existe um cliente com esse email.")

        {:error, error}

      _ ->
        %ClientesSchema{}
        |> ClientesSchema.first_access(params)
        |> formatting_telefone()
        |> Repo.insert()
    end
  end

  defp update_first_access(cliente, params) do
    ClientesSchema.first_access(cliente, params)
    |> formatting_telefone()
    |> Repo.update()
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
       cliente = Map.put(cliente, "sit_app", "A")

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

  def insert_or_update(%{"cnpj_cpf" => cnpj_cpf} = params) do
    params = Map.put(params, "sit_app", "A")

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

  def insert_or_update_first(%{"email" => email} = params) do
    with nil <- Repo.get_by(ClientesSchema, email: email, cadastrado: false) do
      __MODULE__.create(params)
    else
      cliente ->
        __MODULE__.update(cliente, params)
    end
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

  def formatting_dtnasc(dtnasc) do
    [dia, mes, ano] = String.split(dtnasc, ["/"])
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

  def verify_field_cadastrado(email) do
    cliente =
      ClientesSchema
      |> where([c], c.email == ^email)
      |> select([c], %{cadastrado: c.cadastrado})
      |> first()
      |> Repo.one()

    case cliente.cadastrado do
      true -> {:ok, true}
      false -> {:ok, false}
    end
  end

  def get_token_sms() do
    url = "https://api.directcallsoft.com/request_token"

    params =
    Map.put(Map.new(), "client_id", "suporte@centraloftalmica.com")
    |> Map.put("client_secret", "0754943")

    uri = URI.encode_query(params)

    {:ok, resp} = HTTPoison.post(url, uri, [{"Content-Type", "application/x-www-form-urlencoded"}])

    {:ok, Jason.decode!(resp.body)}
  end

  def send_sms(%{phone_number: phone_number} = params, code_sms) do
    text = "Central Oftálmica - Seu Código de Verificação é: #{code_sms}"
    {:ok, token} = get_token_sms()
    params =
      Map.put(params, :texto, text)
      |> Map.put(:origem, 5527996211804)
      |> Map.put(:destino, phone_number)
      |> Map.put(:access_token, token["access_token"])

    uri = URI.encode_query(params)

    url = "https://api.directcallsoft.com/sms/send"

    {:ok, resp} = HTTPoison.post(url, uri, [{"Content-Type", "application/x-www-form-urlencoded"}])

    {:ok, Jason.decode!(resp.body)}
  end

  def confirmation_sms(params) do
    case Repo.get_by(ClientesSchema, telefone: params["telefone"]) do
      nil ->
      %ClientesSchema{}
      |> ClientesSchema.sms(params)
      |> Repo.insert()

      changeset ->
        update_telefone(changeset, params)
    end
  end

  def update_telefone(changeset, params) do
    changeset
    |> ClientesSchema.sms(params)
    |> Repo.update()
  end

  def formatting_phone_number(phone_number) do
    phone_number =
      Integer.to_string(phone_number)
      |> String.slice(4..12)
  end

  def confirmation_code(code_sms, phone_number) do
    phone_number = String.slice(phone_number, 4..12)

    cliente =
      ClientesSchema
      |> where([c], c.code_sms == ^code_sms and ^phone_number == c.telefone)
      |> first()
      |> Repo.one()

    case cliente do
      nil -> {:error, :invalid_code_sms}
      cliente -> {:ok, cliente}
    end
  end
end
