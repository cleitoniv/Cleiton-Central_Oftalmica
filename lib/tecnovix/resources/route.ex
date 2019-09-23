defmodule Tecnovix.Resource.Routes do
  defmacro __using__(model) do
    quote do
      @doc false
      def index(var!(conn), params = %{"page" => page, "page_size" => page_size}) do
        list = unquote(model).index(unquote(model).get_schema(), [], params)

        var!(conn)
        |> put_status(:ok)
        |> render("index.json", list: list)
      end

      @doc false
      def create(var!(conn), %{"param" => param}) do
        with {:ok, item} <- unquote(model).create(param) do
          var!(conn)
          |> put_status(:created)
          |> render("show.json", item: item)
        end
      end

      @doc false
      def show(var!(conn), %{"id" => id}) do
        case unquote(model).show(id) do
          :empty ->
            :empty

          {:ok, item} ->
            var!(conn)
            |> put_status(:found)
            |> render("show.json", item: item)
        end
      end

      @doc false
      def update(var!(conn), %{"id" => id, "param" => param}) do
        with {:ok, item} <- unquote(model).show(id),
             {:ok, updated_item} <- unquote(model).update(item, param) do
          var!(conn)
          |> put_status(:ok)
          |> render("show.json", item: updated_item)
        end
      end

      @doc false
      def delete(var!(conn), %{"id" => id}) do
        with {:ok, item} <- unquote(model).show(id),
             {:ok, deleted_item} <- unquote(model).delete(item) do
          var!(conn)
          |> put_status(:ok)
          |> render("show.json", item: deleted_item)
        end
      end

      defoverridable show: 2
      defoverridable delete: 2
      defoverridable index: 2
      defoverridable create: 2
      defoverridable update: 2
    end
  end
end
