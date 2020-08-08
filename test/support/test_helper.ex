defmodule Tecnovix.TestHelp do
  def single_json(path) do
    File.read!("test/support/single_insert/" <> path)
    |> Jason.decode!()
  end

  def multi_json(path) do
    File.read!("test/support/multi_insert/" <> path)
    |> Jason.decode!()
  end
end
