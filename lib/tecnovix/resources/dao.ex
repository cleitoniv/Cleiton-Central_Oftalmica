defmodule Tecnovix.DAO do
  @moduledoc """
  Modulo de CRUD basico, todas as funcoes definidas aqui seram escritas no modulo que invocar `use Tecnovix.DAO`

  A macro `__using__`, espera um schema pre-definido todas as funcoes podem ser reescritas inplace pelo modulo
  que invoca a macro.
  """

  alias Tecnovix.Repo
  import Ecto.Query
  
  @doc """
  Helper que ajuda a buildar consultas com multiplas condicoes, usa a funcao `Ecto.Query.dynamic/2`, e espera
  `conditions` como um array de `Ecto.Query.dynamic/2`
  """
  defp build_fragments(conditions) when is_list(conditions) do
    Enum.reduce(conditions, dynamic(true), fn condition, acc ->
      dynamic([p], ^acc and ^condition)
    end)
  end

  @doc """
  Funcao que retorna multiplos resultados do schema passado. 
  
  Lembrando que para abrir chaves estrangeiras, todos os preloads devem ser definidos antes pelo schema passado
  ou seja, para abrir todos os States com as suas cidade, deve ser 
  `State |> preload(:cities) |> Tecnovix.DAO.index([])`, dessa forma cada estado tera uma chave cities com um array
  de cidades e sera filtrado pelas condicoes passadas no segundo argumento.  
  """
  def index(schema, conditions) do
    schema
    |> select([u], u)
    |> where(^build_fragments(conditions))
    |> Repo.all()
  end

  @doc """
  Funcao que cria um registro no banco de dados do Schema passado.

  Na macro de `use Tecnovix.DAO, Schema`, os parametros schema e changeset sao passados automaticamente.
  Gerando uma funcao que espera apenas `params` como parametro.
  """
  def create(schema, changeset, params \\ %{}) do
    schema.changeset(changeset, params)
    |> Repo.insert()
  end

  @doc """
  Funcao que retorna um unico registro filtrado por ID.

  Originalmente `Tecnovix.Repo.get/2` retorna nil ou uma instancia do schema passado, mas para auxiliar no uso
  de pattern matching foram adicionados `:empty` e `{:ok, %Ecto.Schema.t}`. 
  """
  def show(schema, id) do
    case Repo.get(schema, id) do
      nil -> :empty
      v -> {:ok, v}
    end
  end

  @doc """
  Funcao que atualiza um registro no banco.

  Espera um `%Ecto.Changeset{}` com uma chave id.
  """
  def update(schema, changeset, params \\ %{}) do
    schema.changeset(changeset, params)
    |> Repo.update()
  end

  @doc """
  Funcao que deleta um registro do banco.

  Espera um `%Ecto.Changeset{}` com uma chave id.
  """
  def delete(changeset) do
    Repo.delete(changeset)
  end

  defmacro __using__(schema) do
    quote do
      @doc false
      def get_schema() do
        unquote(schema)
      end
      @doc false
      def index(sc, conditions) do
        Tecnovix.DAO.index(sc, conditions)
      end
      @doc false
      def create(params) do
        Tecnovix.DAO.create(unquote(schema), %unquote(schema){}, params)
      end
      @doc false
      def update(changeset, params) do
        Tecnovix.DAO.update(unquote(schema), changeset, params)
      end
      @doc false
      def delete(changeset) do
        Tecnovix.DAO.delete(changeset)
      end
      @doc false
      def show(id) do
        Tecnovix.DAO.show(unquote(schema), id)
      end

      defoverridable index: 2
      defoverridable create: 1
      defoverridable update: 2
      defoverridable delete: 1
      defoverridable show: 1
    end
  end
end
