defmodule Tecnovix.Services.ConfirmationSMS do
  use GenServer
  import Ecto.Query
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema

  def delete_code(code_sms, phone_number) do
      phone_number = Tecnovix.ClientesModel.formatting_phone_number(phone_number)

      ClientesSchema
      |> where([c], c.code_sms == ^code_sms and ^phone_number == c.telefone)
      |> first()
      |> Repo.one()
      |> Repo.delete()
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :state, name: :confirmation_sms)
  end

  def init(_) do
    {:ok, :state}
  end

  def handle_info({:ok, code_sms, phone_number}, state) do
    Process.send_after(self(), {:ok, delete_code(code_sms, phone_number)}, 60000)
    {:noreply, state}
  end

  def handle_call({:confirmation, code_sms, phone_number}, _from, state) do
    Process.send_after(self(), {:ok, code_sms, phone_number}, 60000)

    {:reply, {:ok, state}, state}
  end

  def deleting_coding(code_sms, phone_number) do
    GenServer.call(:confirmation_sms, {:confirmation, code_sms, phone_number})
  end
end
