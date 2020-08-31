# defmodule Tecnovix.Services.Order do
#   use GenServer
#   alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
#
#   def start_link(_) do
#     GenServer.start_link(__MODULE__, :state, name: :order)
#   end
#
#   def init(_state) do
#     with {:ok, order} <- Wirecard.get()
#   end
# end
