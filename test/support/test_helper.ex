defmodule Tecnovix.TestHelp do
  def single_json(path) do
    File.read!("test/support/single_insert/" <> path)
    |> Jason.decode!()
  end

  def multi_json(path) do
    File.read!("test/support/multi_insert/" <> path)
    |> Jason.decode!()
  end

  def cliente() do
    File.read!("test/support/protheus/cliente.json")
    |> Jason.decode!()
  end
end
