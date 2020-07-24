defmodule Tecnovix.AtendPrefClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.AtendPrefClienteSchema

  def create(params, cliente_id) do
    case __MODULE__.get_by(cliente_id: cliente_id) do
      nil -> __MODULE__.create(params)
      atend_pref -> __MODULE__.update(atend_pref, params)
    end
  end
end
