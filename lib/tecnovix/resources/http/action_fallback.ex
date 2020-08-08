defmodule Tecnovix.Resources.Fallback do
  use TecnovixWeb, :controller

  def call(conn, {:error, :cliente_desativado}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Cliente desativado."}))
    |> halt()
  end

  def call(conn, {:error, :not_authorized}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Cliente não autorizado."}))
    |> halt()
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Recurso não encontrado."}))
    |> halt()
  end

  def call(conn, {:error, :invalid_parameter}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Parametro inválido."}))
    |> halt()
  end

  def call(conn, {:error, :inatived}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"success" => false, "data" => "Usuario inativo."}))
    |> halt()
  end

  def call(conn, {:error, :not_list}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      401,
      Jason.encode!(%{"success" => false, "data" => "Não foi possível listar os usuários."})
    )
    |> halt()
  end
end
