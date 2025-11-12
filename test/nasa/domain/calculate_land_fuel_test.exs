defmodule Nasa.Domain.Land.CalculateFuelTest do
  use ExUnit.Case, async: true
  alias Nasa.Domain.Land.CalculateFuel

  doctest CalculateFuel

  describe "Calculate land fuel" do
    test "sucess" do
      assert Decimal.compare(
               Decimal.new("13447"),
               CalculateFuel.land(mass: Decimal.new("28801"), gravity: Decimal.new("9.807"))
             ) == :eq
    end

    test "mass is 0" do
      assert Decimal.compare(
               Decimal.new("0"),
               CalculateFuel.land(mass: Decimal.new("0"), gravity: Decimal.new("9.807"))
             ) == :eq
    end
  end
end
