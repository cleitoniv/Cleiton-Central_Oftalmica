defmodule Tecnovix.AgendaModel do
  use Tecnovix.DAO, schema: Tecnovix.AgendaSchema
  alias Tecnovix.AgendaSchema
  alias Tecnovix.Repo
  import Ecto.Query

  def create(params) do
    IO.inspect params
  end

  def get_all_schedules(seller_id) do
    agendamentos =
      AgendaSchema
      |> where([a], a.vendedor_id == ^seller_id)
      |> Repo.all

    {:ok, agendamentos}
  end

  def get_schedule_by_seller(seller_id) do
    case Repo.get_by(AgendaSchema, vendedor_id: seller_id) do
      nil -> {:error, :not_found}
      schedule -> {:ok, schedule}
    end
  end

  def get_ufs() do
    url_base = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"

    {:ok, resp} = HTTPoison.get(url_base)

    {:ok, Jason.decode!(resp.body)}
  end

  def get_citys(uf) do
    url_base = "https://servicodados.ibge.gov.br/api/v1/localidades/estados/#{uf}/municipios"

    HTTPoison.get(url_base)
  end

  def get_uf_by_region(regiao, ufs) do
    [_, sigla_estado] = String.split(regiao)

    uf =
      Enum.find(ufs, fn uf ->
        uf["sigla"] == sigla_estado
      end)

    {:ok, uf["id"]}
  end
end
