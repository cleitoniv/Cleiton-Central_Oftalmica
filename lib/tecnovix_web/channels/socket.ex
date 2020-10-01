# defmodule TecnovixWeb.Socket do
#   use Phoenix.Socket
#
#   channel "cliente:*", TecnovixWeb.Channel
#
#   def connect(%{"token" => token}, socket, _connect_info) do
#     {:ok, cliente} = cliente_auth(token)
#
#     {:ok, assign(socket, :user_id, cliente.id)}
#   end
#
#   def cliente_auth(token) do
#     with {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}),
#          {:ok, user} <- Tecnovix.ClientesModel.search_register_email(jwt.fields["email"]),
#          true <- user.sit_app != "D" do
#            {:ok, user}
#     else
#       false ->
#         {:error, :cliente_desativado}
#
#       _ -> user_cliente_auth()
#     end
#   end
#
#   def user_cliente_auth(token) do
#     with {true, jwt = %JOSE.JWT{}, _jws} <- verify_jwt({:init, token}),
#          {:ok, user} <- Tecnovix.UsuariosClienteModel.search_register_email(jwt.fields["email"]),
#          true <- user.status == 1 do
#            {:ok, user}
#     else
#       false ->
#         {:error, :inatived}
#
#       _ -> {:error, :not_authorized}
#     end
#   end
# end
