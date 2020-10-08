defmodule Tecnovix.Wirecard do
  def stub() do
    case Mix.env() do
      :prod -> Tecnovix.Wirecard.Prod
      :dev -> Tecnovix.Wirecard.Test
      :test -> Tecnovix.Wirecard.Test
    end
  end
end
