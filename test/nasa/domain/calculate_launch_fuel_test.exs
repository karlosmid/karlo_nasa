defmodule Nasa.Domain.Launch.CalculateFuelTest do
  use ExUnit.Case, async: true
  alias Nasa.Domain.Launch.CalculateFuel

  doctest CalculateFuel

  describe "Calculate launch fuel" do
    test "sucess" do
      assert Decimal.compare(
               Decimal.new("19772"),
               CalculateFuel.launch(mass: Decimal.new("28801"), gravity: Decimal.new("9.807"))
             ) == :eq
    end

    test "mass is 0" do
      assert Decimal.compare(
               Decimal.new("0"),
               CalculateFuel.launch(mass: Decimal.new("0"), gravity: Decimal.new("9.807"))
             ) == :eq
    end
  end
end
