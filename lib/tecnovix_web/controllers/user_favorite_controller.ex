defmodule TecnovixWeb.UserFavoriteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.UserFavoriteModel

  action_fallback Tecnovix.Resources.Fallback

end
