defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema

  alias Tecnovix.{
    PreDevolucaoSchema,
    NotificacoesClienteModel,
    ClientesSchema,
    Repo,
    ItensPreDevolucaoSchema
  }

  alias Tecnovix.ContratoDeParceriaSchema, as: Contrato
  import Ecto.Query

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn devolucao ->
       with nil <-
              Repo.get_by(PreDevolucaoSchema,
                filial: devolucao["filial"],
                cod_pre_dev: devolucao["cod_pre_dev"]
              ) do
         create(devolucao)
       else
         changeset ->
           Repo.preload(changeset, :items)
           |> __MODULE__.update(devolucao)
       end
     end)}
  end

  def insert_or_update(%{"filial" => filial, "cod_pre_dev" => cod_pre_dev} = params) do
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: filial, cod_pre_dev: cod_pre_dev) |> IO.inspect do
      {:ok, changeset} = __MODULE__.create(params)
      {:ok, Repo.preload(changeset, :items)}
    else
      devolucao ->
        Repo.preload(devolucao, :items)
        |> __MODULE__.update(params)
    end
  end

  def insert_or_update(params) do
    IO.inspect params
    {:error, :invalid_parameter}
  end

  def create(cliente, params, tipo) do
    devolucao = pre_devolucao(cliente, params, tipo)

    %PreDevolucaoSchema{}
    |> PreDevolucaoSchema.changeset(devolucao)
    |> Repo.insert()
  end

  def create(cliente, params) do
    devolucao =
      Enum.map(params, fn param ->
        devolucao =
          cliente
          |> pre_devolucao(param)
          |> itens_pre_devolucao()

        {:ok, item} =
          %PreDevolucaoSchema{}
          |> PreDevolucaoSchema.changeset(devolucao)
          |> Repo.insert()

        item
      end)

    {:ok, devolucao}
  end

  # Ajeitando o mapa da tabela PRE DEVOLUCAO
  def pre_devolucao(cliente, params, tipo) do
    %{
      "client_id" => cliente.id,
      "tipo_pre_dev" => tipo,
      "loja" => cliente.loja,
      "cliente" => cliente.codigo,
      "items" => params
    }
  end

  def pre_devolucao(cliente, _params) do
    %{
      "client_id" => cliente.id,
      "tipo_pre_dev" => "C",
      "loja" => cliente.loja,
      "cliente" => cliente.codigo
    }
  end

  # Ajeitando o mapa da tabela dos Itens
  def itens_pre_devolucao(params) do
    params
    |> Map.put("filial", params["filial"])
    |> new_product()
    |> old_product()
  end

  # Incluindo no mapa de itens, campos e valores sobre o produto novo
  def new_product(params) do
    params
    |> Map.put("prod_subs", params["prod_subs"])
    |> Map.put("olho", params["olho"])
  end

  # Incluindo no mapa de itens, campos e valores sobre o produto velho
  def old_product(params) do
    params
    |> Map.put("num_de_serie", params["num_serie"])
    |> Map.put("quant", 1)
    |> Map.put("produto", params["title"])
  end

  def get_contrato(cliente) do
    case Repo.get_by(Contrato, cliente_id: cliente.id) do
      nil -> {:error, :not_found}
      contrato -> {:ok, contrato}
    end
  end

  def insert_dev(cliente, products) do
    dev = pre_devolucao(cliente, products)

    items =
      Enum.map(products, fn product ->
        _old =
          old_product(product)
          |> Map.put("tipo", "C")
      end)

    product_ready = Map.put(dev, "items", items)

    %PreDevolucaoSchema{}
    |> PreDevolucaoSchema.changeset(product_ready)
    |> Repo.insert()
  end

  def insert_pre_devolucao(
        cliente_id,
        %{
          groups: _groups,
          devolutions: devolutions,
          products: _products,
          tipo: tipo
        }
      ) do
    cliente = Repo.get(ClientesSchema, cliente_id)

    case create(cliente, devolutions, tipo) do
      {:ok, dev} ->
        NotificacoesClienteModel.solicitation_devolution(dev, cliente)

      erro ->
        erro
    end
  end

  def get_devolucoes(filtro) do
    devs =
      PreDevolucaoSchema
      |> preload(:items)
      |> where([p], p.status == ^filtro)
      |> Repo.all()

    {:ok, devs}
  end

  def serial_authorized?(num_serie) do
    case Repo.get_by(ItensPreDevolucaoSchema, num_de_serie: num_serie) do
      nil -> {:ok, true}
      _serial -> {:error, :repeated}
    end
  end
end
