defmodule Nasa.Domain.PathFuel do
  @moduledoc """
  Logic for calculating fuel path
  """
  alias Nasa.Domain

  @gravity [earth: Decimal.new("9.807"), moon: Decimal.new("1.62"), mars: Decimal.new("3.711")]

  @doc """
  Calculates path fuel

  ## Parameters

      * `mass` - object mass
      * `planet` - destination planet
      * `action` - how to move to planet

  ## Examples

      iex> Nasa.Domain.PathFuel.fuel([mass: Decimal.new("28801"), planet: "earth", action: "land"])
      Decimal.new("13447")
  """
  @spec fuel(mass: binary(), planet: binary(), action: binary()) :: Decimal.t() | {:error, binary}
  def fuel(mass: _mass, planet: planet, action: _action)
      when planet not in ["earth", "moon", "mars"],
      do: {:error, "Unsupported planet: #{planet}."}

  def fuel(mass: _mass, planet: _planet, action: action) when action not in ["land", "launch"],
    do: {:error, "Unsupported action: #{action}."}

  def fuel(mass: mass, planet: planet, action: action)
      when planet in ["earth", "moon", "mars"] and action in ["land", "launch"] do
    mass = Decimal.new(mass)
    gravity = Keyword.get(@gravity, String.to_existing_atom(planet))

    case action do
      "launch" -> Domain.Launch.CalculateFuel.launch(mass: mass, gravity: gravity)
      "land" -> Domain.Land.CalculateFuel.land(mass: mass, gravity: gravity)
    end
  rescue
    error in Decimal.Error ->
      {:error, "Mass is not a number #{Exception.message(error)}"}
  end

  def fuel(_), do: {:error, "unsupported action or planet"}

  @doc """
  Recalculates fuel for a sequence of paths, accounting for the additional mass
  from fuel required for subsequent paths in the sequence.


  ## Parameters

      * `paths` - A list of path maps, where each map contains:
        - `:action` - The action to perform ("launch" or "land")
        - `:planet` - The planet name ("earth", "moon", or "mars")
        - `:mass` - The initial mass (Decimal or binary string)
        - `:fuel` - The initial fuel calculation (Decimal)

  ## Returns

  A list of path maps with recalculated `:mass` and `:fuel` values. Each map
  contains:
  - `:action` - The action (unchanged)
  - `:planet` - The planet (unchanged)
  - `:mass` - The recalculated mass (Decimal)
  - `:fuel` - The recalculated fuel (Decimal)

  ## Examples

      iex> paths = [
      ...>   %{action: "launch", planet: "earth", mass: "28801", fuel: Decimal.new("19772")},
      ...>   %{action: "land", planet: "moon", mass: "28801", fuel: Decimal.new("13447")}
      ...> ]
      iex> result = PathFuel.recalculate_fuel(paths: paths)
      iex> length(result)
      2
      iex> Enum.at(result, 0)[:action]
      "launch"
  """
  @spec recalculate_fuel(keyword()) :: [map()]
  def recalculate_fuel(paths: []), do: []
  def recalculate_fuel(paths: [path]), do: [path]

  @dialyzer {:nowarn_function, recalculate_fuel: 1}
  def recalculate_fuel(paths: paths) do
    after_paths(paths: paths)
    |> Enum.map(fn {path, after_paths} ->
      %{action: action, planet: planet, mass: mass} = path

      additional_fuel =
        recalculate_fuel(paths: after_paths)
        |> Enum.reduce(Decimal.new("0"), fn item, acc ->
          Decimal.add(acc, Map.get(item, :fuel, Decimal.new("0")))
        end)

      new_mass = Decimal.add(mass, additional_fuel)
      new_fuel = fuel(mass: new_mass, planet: planet, action: action)
      %{action: action, planet: planet, mass: new_mass, fuel: new_fuel}
    end)
  end

  defp after_paths(paths: paths) do
    {_suffix, result} =
      paths
      |> Enum.reverse()
      |> Enum.reduce({[], []}, fn elem, {suffix, acc} ->
        new_acc = [{elem, suffix} | acc]
        new_suffix = [elem | suffix]
        {new_suffix, new_acc}
      end)

    result
  end
end
