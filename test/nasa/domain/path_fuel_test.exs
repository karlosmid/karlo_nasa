defmodule Nasa.Domain.PathFuelTest do
  use ExUnit.Case, async: true
  alias Nasa.Domain.PathFuel

  doctest PathFuel

  describe "Calculate path fuel" do
    test "sucess" do
      assert Decimal.compare(
               Decimal.new("19772"),
               PathFuel.fuel(mass: "28801", planet: "earth", action: "launch")
             ) == :eq
    end

    test "wrong planet" do
      assert PathFuel.fuel(mass: "28801", planet: "venus", action: "launch") ==
               {:error, "Unsupported planet: venus."}
    end

    test "wrong action" do
      assert PathFuel.fuel(mass: "28801", planet: "earth", action: "drift") ==
               {:error, "Unsupported action: drift."}
    end

    test "wrong mass" do
      assert PathFuel.fuel(mass: "AAA", planet: "earth", action: "launch") ==
               {:error, "Mass is not a number : number parsing syntax: \"AAA\""}
    end
  end

  describe "Recalcualte fuel" do
    test "Moon mission" do
      mass = "28801"
      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "launch")
      launch_earth = %{action: "launch", planet: "earth", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "moon", action: "land")
      land_moon = %{action: "land", planet: "moon", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "moon", action: "launch")
      launch_moon = %{action: "launch", planet: "moon", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "land")
      land_earth = %{action: "land", planet: "earth", mass: mass, fuel: path_fuel}

      assert Decimal.compare(
               Decimal.new("51898"),
               PathFuel.recalculate_fuel(
                 paths: [launch_earth, land_moon, launch_moon, land_earth]
               )
               |> Enum.reduce(Decimal.new("0"), fn %{
                                                     action: _action,
                                                     planet: _planet,
                                                     mass: _mass,
                                                     fuel: fuel
                                                   },
                                                   acc ->
                 Decimal.add(acc, fuel)
               end)
             ) == :eq
    end

    test "Mars mission" do
      mass = "14606"
      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "launch")
      launch_earth = %{action: "launch", planet: "earth", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "mars", action: "land")
      land_mars = %{action: "land", planet: "mars", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "mars", action: "launch")
      launch_mars = %{action: "launch", planet: "mars", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "land")
      land_earth = %{action: "land", planet: "earth", mass: mass, fuel: path_fuel}

      assert Decimal.compare(
               Decimal.new("33388"),
               PathFuel.recalculate_fuel(
                 paths: [launch_earth, land_mars, launch_mars, land_earth]
               )
               |> Enum.reduce(Decimal.new("0"), fn %{
                                                     action: _action,
                                                     planet: _planet,
                                                     mass: _mass,
                                                     fuel: fuel
                                                   },
                                                   acc ->
                 Decimal.add(acc, fuel)
               end)
             ) == :eq
    end

    test "Passanger ship mission" do
      mass = "75432"
      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "launch")
      launch_earth = %{action: "launch", planet: "earth", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "moon", action: "land")
      land_moon = %{action: "land", planet: "moon", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "moon", action: "launch")
      launch_moon = %{action: "launch", planet: "moon", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "mars", action: "land")
      land_mars = %{action: "land", planet: "mars", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "mars", action: "launch")
      launch_mars = %{action: "launch", planet: "mars", mass: mass, fuel: path_fuel}

      path_fuel = PathFuel.fuel(mass: mass, planet: "earth", action: "land")
      land_earth = %{action: "land", planet: "earth", mass: mass, fuel: path_fuel}

      assert Decimal.compare(
               Decimal.new("212161"),
               PathFuel.recalculate_fuel(
                 paths: [launch_earth, land_moon, launch_moon, land_mars, launch_mars, land_earth]
               )
               |> Enum.reduce(Decimal.new("0"), fn %{
                                                     action: _action,
                                                     planet: _planet,
                                                     mass: _mass,
                                                     fuel: fuel
                                                   },
                                                   acc ->
                 Decimal.add(acc, fuel)
               end)
             ) == :eq
    end
  end
end
