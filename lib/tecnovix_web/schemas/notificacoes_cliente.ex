defmodule Tecnovix.NotificacoesClienteSchema do
use Ecto.Schema
import Ecto.Changeset

  schema "notificacoes_cliente" do
    field :cliente_id, :integer
    field :data, :utc_datetime
    field :titulo, :string
    field :descricao, :string
    field :enviado, :integer
    field :lido, :integer
    field :tipo_ref, :string
    field :tipo_ref_id, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :data, :titulo, :descricao, :enviado, :lido, :tipo_ref, :tipo_ref_id])
    |> validate_required([:cliente_id, :data, :titulo])
  end
end
