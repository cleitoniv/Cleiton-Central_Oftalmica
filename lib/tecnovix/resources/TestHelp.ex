defmodule Tecnovix.TestHelp do
  def single_json(path) do
    File.read!("test/support/single_insert/" <> path)
    |> Jason.decode!()
  end

  def multi_json(path) do
    File.read!("test/support/multi_insert/" <> path)
    |> Jason.decode!()
  end

  def error_multi(path) do
    File.read!("test/support/erros_multi_insert/" <> path)
    |> Jason.decode!()
  end

  def cliente() do
    File.read!("test/support/protheus/cliente.json")
    |> Jason.decode!()
  end

  def cliente_cnpj() do
    File.read!("test/support/protheus/cliente_cnpj.json")
    |> Jason.decode!()
  end

  def product_client() do
    File.read!("test/support/protheus/product_client.json")
    |> Jason.decode!()
  end

  def items(path) do
    File.read!("test/support/wirecard/" <> path)
    |> Jason.decode()
  end
end
