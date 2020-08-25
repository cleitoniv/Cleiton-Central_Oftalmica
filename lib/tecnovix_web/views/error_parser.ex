defmodule TecnovixWeb.ErrorParserView do
  defmacro multi_parser(render, identifiers) do
    quote do
      def render(unquote(render), %{item: item}) when is_list(item) do
        items =
          Enum.filter(
            item,
            fn
              {:ok, cliente} -> false
              {:error, changeset} -> true
            end
          )
          |> Enum.map(fn
            {:error, changeset} ->
              TecnovixWeb.ChangesetView.render("multi_error.json", %{
                changeset: changeset,
                identifiers:
                  Enum.map(
                    unquote(identifiers),
                    fn
                      id -> {id, Map.get(changeset.changes, id)}
                    end
                  )
                  |> Enum.into(%{})
              })
          end)

        %{data: items}
      end
    end
  end
end
