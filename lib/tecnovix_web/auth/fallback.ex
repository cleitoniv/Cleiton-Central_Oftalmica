defmodule TecnovixWeb.Auth.Fallback do

  use Phoenix.Controller
  import Plug.Conn

  def call(conn, %Ecto.Changeset{valid: false}) do
    conn
    |> resp(:bad_request, "INVALID REQUEST")
    |> send_resp()
  end
end
