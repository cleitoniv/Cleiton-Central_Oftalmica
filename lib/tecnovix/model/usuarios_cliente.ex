defmodule Tecnovix.UsuariosClienteModel do
  use Tecnovix.DAO, schema: Tecnovix.UsuariosClienteSchema
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.ClientesSchema
  alias Tecnovix.Repo
  import Ecto.Query

  def unique_email(%{"email" => email} = params) do
    with nil <- Repo.get_by(UsuariosClienteSchema, email: email),
         nil <- Repo.get_by(ClientesSchema, email: email) do
      {:ok, email}
    else
      usuario ->
        case usuario.status == 0 and usuario.email == email do
          true ->
            new_password = String.slice(Repo.generate_event_id(), 6..11)

            UsuariosClienteSchema
            |> where([u], u.email == ^email)
            |> update([u], set: [status: 1, cargo: ^params["cargo"], nome: ^params["nome"]])
            |> Repo.update_all([])

            {:ativo, usuario, new_password}

          false ->
            error =
              %Tecnovix.UsuariosClienteSchema{}
              |> Ecto.Changeset.change(%{})
              |> Ecto.Changeset.add_error(:email, "Esse email já esta cadastrado.")

            {:error, error}
        end
    end
  end

  def show_users(cliente_id) do
    usuarios =
      UsuariosClienteSchema
      |> where([u], u.status == 1 and u.cliente_id == ^cliente_id)
      |> Repo.all()

    {:ok, usuarios}
  end

  def cliente_id_filter(params) do
    dynamic([a], a.cliente_id == ^params["cliente_id"])
  end

  def status_filter(params) do
    dynamic([u], u.status == ^params["status"])
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
    # usuarios =
    #   UsuariosClienteSchema
    #   |> where([u], u.cliente_id == ^cliente.id and u.id == ^id)
    #   |> update([u], set: [status: 0])
    #   |> Repo.update_all([])

    # {:ok, usuarios}

    usuario =
      UsuariosClienteSchema
      |> where([u], u.cliente_id == ^cliente.id and u.id == ^id)
      |> preload(:logs_cliente)
      |> first()
      |> Repo.one()

    Repo.delete(usuario)
  end
end
