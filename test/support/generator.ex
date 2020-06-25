defmodule Tecnovix.Support.Generator do
  def user_param() do
    %{
      "email" => "thiagoboeker#{Ecto.UUID.autogenerate()}@gmail.com",
      "fisica_jurid" => "F",
      "cnpj_cpf" => String.slice(Ecto.UUID.autogenerate(), 1..14)
    }
  end

  def sync_users() do
    %{
      username: "Victor",
      password: "123456"
    }
  end
end
