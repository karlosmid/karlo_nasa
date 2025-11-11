defmodule Nasa.Domain.CalculateFuel do
  @moduledoc """
  Calculates required fuel
  """
  @doc """
  Calculates required launch fuel for an object.

  ## Parameteres

      * `mass` - object mass
      * `gravity` - planet gravity
      * `param1` - first constant
      * `param2` - second constant
      * `total` - toal fuel

  ## Examples

      iex> Nasa.Domain.CalculateFuel.calculate([mass: Decimal.new("28801"), gravity: Decimal.new("9.807"), param1: Decimal.new("0.042"), param2: Decimal.new("33"), total: Decimal.new("0")])
      Decimal.new("19747")
  """
  @spec calculate(
          mass: Decimal.t(),
          gravity: Decimal.t(),
          param1: Decimal.t(),
          param2: Decimal.t(),
          total: Decimal.t()
        ) :: Decimal.t() | {:error, binary()}
  def calculate(mass: mass, gravity: gravity, param1: param1, param2: param2, total: total)
      when mass > 0 do
    fuel =
      mass
      |> Decimal.mult(gravity)
      |> Decimal.mult(param1)
      |> Decimal.sub(param2)
      |> Decimal.round(0, :floor)
      |> Decimal.to_integer()

    calculate(
      mass: fuel,
      gravity: gravity,
      param1: param1,
      param2: param2,
      total: Decimal.add(total, fuel)
    )
  end

  def calculate(
        mass: mass,
        gravity: _gravity,
        param1: _param1,
        param2: _param2,
        total: total
      ),
      do: Decimal.sub(total, mass)
end
