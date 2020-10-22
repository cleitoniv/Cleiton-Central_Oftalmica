defmodule Tecnovix.UsuariosClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.UsuariosClienteSchema
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.Repo
  import Ecto.Query

  def show_users() do
    UsuariosClienteSchema
    |> Repo.all()
  end

  def cliente_id_filter(params) do
    dynamic([a], a.cliente_id == ^params["cliente_id"])
  end

  def update(user, params) do
    user
    |> UsuariosClienteSchema.update(params)
    |> Repo.update()
  end

  def update_senha(user, params) do
    user
    |> UsuariosClienteSchema.update_senha(params)
    |> Repo.update()
  end

  def search_user(id) do
    case Repo.get(UsuariosClienteSchema, id) do
      nil ->
        {:error, :not_found}

      usuario ->
        {:ok, usuario}
    end
  end

  def search_register_email(email) do
    case Repo.get_by(UsuariosClienteSchema, email: email) do
      nil ->
        {:error, :not_found}

      usuario ->
        {:ok, usuario}
    end
  end

  def delete_users(id, cliente) do
    usuarios =
      UsuariosClienteSchema
      |> where([u], u.cliente_id == ^cliente.id and u.id == ^id)
      |> first()
      |> Repo.one()
      |> Repo.delete()
  end
end
