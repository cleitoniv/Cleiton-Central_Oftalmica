defmodule Tecnovix.Services.ConfirmationSMS do
  use GenServer
  import Ecto.Query
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema

  def delete_code(code_sms, phone_number) do
    {:ok, kvset} = ETS.KeyValueSet.wrap_existing(:code_confirmation)

    {:ok, telefone} = ETS.KeyValueSet.get(kvset, String.to_atom(phone_number))

    {:ok, confirmation_sms} =
      ETS.KeyValueSet.get(kvset, String.to_atom(phone_number <> "confirmation_sms"))

    {:ok, code_sms_memory} =
      ETS.KeyValueSet.get(kvset, String.to_atom(phone_number <> "code_sms"))

    case telefone == phone_number and code_sms == code_sms_memory and confirmation_sms == 0 do
      true ->
        kvset
        |> ETS.KeyValueSet.delete!(String.to_atom(phone_number))
        |> ETS.KeyValueSet.delete!(String.to_atom(phone_number <> "code_sms"))
        |> ETS.KeyValueSet.delete!(String.to_atom(phone_number <> "confirmation_sms"))

      false ->
        kvset
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :confirmation_sms)
  end

  def init(_) do
    {:ok, :state}
  end

  def handle_info({:ok, code_sms, phone_number}, state) do
    delete_code(code_sms, phone_number)
    {:noreply, state}
  end

  def handle_call({:confirmation, code_sms, phone_number}, _from, state) do
    Process.send_after(self(), {:ok, code_sms, phone_number}, 90000)

    {:reply, {:ok, state}, state}
  end

  def deleting_coding(code_sms, phone_number) do
    GenServer.call(:confirmation_sms, {:confirmation, code_sms, phone_number})
  end
end
