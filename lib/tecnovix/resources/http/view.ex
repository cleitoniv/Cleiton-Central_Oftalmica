defmodule Tecnovix.Resource.View do
  defmacro __using__(model: model) do
    quote bind_quoted: [model: model] do
      use TecnovixWeb, :view

      @doc false
      def render("index.json", %{list: list}) do
        %{
          success: true,
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
        %{success: true, data: __MODULE__.render("item.json", %{item: item})}
      end

      @doc false
      def render("item.json", %{item: t} = item) do
        # Todo modulo de View deve implementar uma funcao `build/1` para renderizar o item
        __MODULE__.build(item)
      end
    end
  end
end
