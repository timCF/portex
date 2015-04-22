defmodule PortexTest do
  use ExUnit.Case

  test "the truth" do
    assert :ok == Portex.open(:nodejs, "node -i")
    assert Portex.exec(:nodejs, "123\nconsole.log(123);\n", &(Regex.match?(~r/123/, &1)), 3000) |> IO.inspect |> Enum.all?(&(Regex.match?(~r/123/, &1)))
  end
end
