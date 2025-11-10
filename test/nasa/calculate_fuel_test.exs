defmodule Nasa.Domain.CalculateFuelTest do
  use ExUnit.Case, async: true
  alias Nasa.Domain.CalculateFuel

  doctest CalculateFuel

  describe "Calculate launch fuel" do
    test "sucess" do
      assert Decimal.compare(
               Decimal.new("11830"),
               CalculateFuel.launch(mass: Decimal.new("28801"), gravity: Decimal.new("9.807"))
             ) == :eq
    end

    test "constant config error" do
      Application.put_env(:nasa, :launch, values: ["A", "33"])
      assert {:error, "Launch parameters configuration error: : number parsing syntax: \"A\""} = CalculateFuel.launch(mass: Decimal.new("28801"), gravity: Decimal.new("9.807"))
      Application.put_env(:nasa, :launch, values: ["0.042", "33"])
    end
  end
end
