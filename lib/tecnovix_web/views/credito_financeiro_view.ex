defmodule TecnovixWeb.CreditoFinanceiroView do
  use Tecnovix.Resource.View, model: Tecnovix.CreditoFinanceiroModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      valor: item.valor,
      desconto: item.desconto,
      tipo_pagamento: item.tipo_pagamento,
      wirecard_pedido_id: item.wirecard_pedido_id,
      wirecard_pagamento_id: item.wirecard_pagamento_id,
      wirecard_reembolso_id: item.wirecard_reembolso_id
    }
  end
end
