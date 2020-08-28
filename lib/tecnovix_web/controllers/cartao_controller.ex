defmodule TecnovixWeb.CartaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard

  action_fallback Tecnovix.Resources.Fallback
end
