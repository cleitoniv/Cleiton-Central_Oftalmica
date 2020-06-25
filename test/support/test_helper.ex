defmodule Tecnovix.TestHelp do
  def parse_json(path) do
    File.read!("test/support/generators/" <> path)
    |> Jason.decode!()
  end
end
