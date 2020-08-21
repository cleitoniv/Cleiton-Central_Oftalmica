defmodule TecnovixWeb.ChangesetView do
  use TecnovixWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    %{success: false, data: %{errors: translate_errors(changeset)}}
  end
end
