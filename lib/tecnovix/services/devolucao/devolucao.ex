defmodule Tecnovix.Services.Devolucao do
  use GenServer
  alias Tecnovix.PreDevolucaoModel

  def calculate_groups(products) do
    Enum.group_by(products, fn product -> product["group"] end)
    |> Enum.map(fn {group, products} ->
      quantidade =
        Enum.reduce(products, 0, fn map, acc ->
          acc + 1
        end)

      {group, quantidade}
    end)
    |> Enum.into(%{})
  end

  def calculate_series(products) do
    Enum.group_by(products, fn product -> product["num_serie"] end)
    |> Enum.reduce([], fn {key, value}, acc ->
      case Enum.count(value) >= 2 do
        true  -> {:error, :product_repeated}

        false -> value ++ acc
      end
    end)
  end

  def next_step(groups, group, quantidade, products) do
    update_group = Map.put(groups, group, Map.get(groups, group) - quantidade)

    {group, quantidade} =
      case Map.get(update_group, group) do
        qty when qty > 0 ->
          {group, qty}

        _ ->
          Enum.find(update_group, {:no_group, 0}, fn {c_group, quantidade} ->
            quantidade > 0
          end)
      end

    product =
      Enum.find(products, fn product ->
        product["group"] == group
      end)

    {product, update_group, quantidade, group}
  end

  def get_user(id, state) do
    Map.get(state, id)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :services_devolucao)
  end

  def init(_) do
    {:ok, %{}}
  end

  def init_devolution(products, groups) do
    {group, quantidade} = Enum.find(groups, fn {group, quantidade} -> quantidade > 0 end)
    product = Enum.find(products, fn product -> product["group"] == group end)

    {product, quantidade}
  end

  def handle_cast(:debug, state) do
    {:noreply, state}
  end

  def handle_call({:insert, id, products, tipo}, _from, state) do
    groups = calculate_groups(products)

    new_state =
      Map.put(state, id, %{products: products, devolutions: [], groups: groups, tipo: tipo})

    {product, quantidade} = init_devolution(products, groups)

    {:reply, {:ok, %{product: product, quantidade: quantidade}}, new_state}
  end

  def handle_call({:next, id, group, quantidade, devolution}, _from, state) do
    user = get_user(id, state)

    {product, groups, quantidade, group} =
      next_step(user.groups, group, quantidade, user.products)

    user =
      Map.put(user, :devolutions, user.devolutions ++ [devolution])
      |> Map.put(:groups, groups)

    state =
      state
      |> Map.put(id, user)

    resp =
      case group do
        :no_group ->
          PreDevolucaoModel.insert_pre_devolucao(id, user)
          :finish

        _ ->
          {:ok, %{product: product, quantidade: quantidade, group: group}}
      end

    {:reply, resp, state}
  end

  def handle_call({:list, serial}, _from, state) do
    new_state = Map.put(state, serial, serial)

    resp =
      case Map.get(state, serial) do
        nil -> {:ok, :success}
        _ -> {:error, :repeated}
      end

    {:reply, resp, new_state}
  end

  def list(num_serie) do
    GenServer.call(:services_devolucao, {:list, num_serie})
  end

  def insert(products, id, tipo) do
    GenServer.call(:services_devolucao, {:insert, id, products, tipo})
  end

  def next(id, group, quantidade, devolution) do
    GenServer.call(:services_devolucao, {:next, id, group, quantidade, devolution})
  end
end
