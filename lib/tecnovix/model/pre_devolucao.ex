defmodule Tecnovix.PreDevolucaoModel do
  use Tecnovix.DAO, schema: Tecnovix.PreDevolucaoSchema
  alias Tecnovix.{PreDevolucaoSchema, NotificacoesClienteModel, ClientesSchema, Repo}
  alias Tecnovix.ContratoDeParceriaSchema, as: Contrato

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
    with nil <- Repo.get_by(PreDevolucaoSchema, filial: filial, cod_pre_dev: cod_pre_dev) do
      __MODULE__.create(params)
    else
      devolucao ->
        {:ok, devolucao}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def create(cliente, params, tipo) do
    devolucao = pre_devolucao(cliente, params, tipo)

    {:ok, item} =
      %PreDevolucaoSchema{}
      |> PreDevolucaoSchema.changeset(devolucao)
      |> Repo.insert()

    {:ok, item}
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
      "filial" => "N",
      "tipo_pre_dev" => tipo,
      "cod_pre_dev" => String.slice(Ecto.UUID.autogenerate(), 0..5),
      "loja" => cliente.loja,
      "cliente" => cliente.codigo,
      "items" => params
    }
  end

  def pre_devolucao(cliente, params) do
    %{
      "cliente_id" => cliente.id,
      "filial" => "N",
      "tipo_pre_dev" => "C",
      "cod_pre_dev" => String.slice(Ecto.UUID.autogenerate(), 0..5),
      "loja" => cliente.loja,
      "cliente" => cliente.codigo
    }
  end

  # Ajeitando o mapa da tabela dos Itens
  def itens_pre_devolucao(params) do
    params
    |> Map.put("filial", params["filial"])
    |> Map.put("cod_pre_dev", params["cod_pre_dev"])
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
    |> Map.put("num_serie", params["num_serie"])
    |> Map.put("quant", params["quant"])
    |> Map.put("produto", params["title"])
  end

  def get_contrato(cliente) do
    case Repo.get_by(Contrato, cliente_id: cliente.id) do
      nil -> {:error, :not_found}
      contrato -> {:ok, contrato}
    end
  end

  def insert_dev(cliente, products) do
    Enum.map(products, fn product ->
      dev = pre_devolucao(cliente, products)


    product_ready = Map.put(dev, "items", old_product(product))

      %PreDevolucaoSchema{}
      |> PreDevolucaoSchema.changeset(product_ready)
      |> Repo.insert()
      |> IO.inspect
    end)
  end

  def insert_pre_devolucao(cliente_id, %{
        groups: groups,
        devolutions: devolutions,
        products: products,
        tipo: tipo
      }) do
    cliente = Repo.get(ClientesSchema, cliente_id)

    case create(cliente, devolutions, tipo) do
      {:ok, dev} ->
        NotificacoesClienteModel.solicitation_devolution(dev, cliente)

      erro ->
        erro
    end
  end
end
