defmodule Tecnovix.Resource.View do
  defmacro __using__(fields: fields, model: model) do
    quote bind_quoted: [fields: fields, model: model] do
      use TecnovixWeb, :view

      @doc false
      def render("index.json", %{list: list}) do
        %{
          page: list.page_number,
          page_size: list.page_size,
          total: list.total_entries,
          total_pages: list.total_pages,
          data:
            Enum.map(list.entries, fn data -> __MODULE__.render("item.json", %{item: data}) end)
        }
      end

      @doc false
      def render("show.json", %{item: item}) do
        %{data: __MODULE__.render("item.json", %{item: item})}
      end

      @doc false
      def render("item.json", %{item: item}) do
        Map.take(item, unquote(fields))
      end
    end
  end
end
