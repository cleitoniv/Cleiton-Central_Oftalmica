defmodule Tecnovix.LogsClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.LogsClienteSchema
  alias Tecnovix.LogsClienteSchema
  alias Tecnovix.Repo

  def create(ip, usuario, cliente, msg) do
    logs =
      case usuario do
        nil ->
          %{
            "ip" => ip,
            "usuario_cliente_id" => nil,
            "cliente_id" => cliente.id,
            "dispositivo" => "Samsung A30S",
            "acao_realizada" => msg
          }

        usuario ->
          %{
            "ip" => ip,
            "usuario_cliente_id" => usuario.id,
            "cliente_id" => cliente.id,
            "dispositivo" => "Samsung A30S",
            "acao_realizada" => msg
          }
      end

    %LogsClienteSchema{}
    |> LogsClienteSchema.changeset(logs)
    |> Repo.insert()
  end
end
