# defmodule Tecnovix.Services.ProductsByClient do
#   alias Tecnovix.ClientesModel
#   use GenServer

#   def get_client(id) do
#     case ClientesModel.get_client(id) do
#       {:ok, client} -> client

#       _ -> %{}
#     end
#   end

#   def start_link(_) do
#     GenServer.start_link(__MODULE__, %{}, name: :products)
#   end

#   def init(init) do
#     {:ok, init}
#   end

#   def handle_call({:client, current_client}, _from, state) do
#     case state do
#       %{} -> %{}
#       %VendedoresSchema{} -> %{}
#       %ClientSchema{} -> state
#     end

#     {:reply, {:ok, client}, client}
#   end

#   def current_client(current_client) do
#     GenServer.call(:products, {:client, current_client})
#   end
# end
