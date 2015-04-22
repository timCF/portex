defmodule PortexTest do
  use ExUnit.Case

  test "the truth" do
    Portex.open(:nodejs, "node -i")
    Portex.exec("console.log(123);\n", :nodejs, &(Regex.match?(~r/123/, &1)), 3000) |> IO.inspect
    assert 1 + 1 == 2
  end
end
